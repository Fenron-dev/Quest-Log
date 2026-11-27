import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/settings/time_settings.dart';
import '../../core/ui/formatting.dart';
import '../customers/data/customers_repository.dart';
import '../notes/data/notes_repository.dart';
import '../projects/data/projects_repository.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/task_actions.dart';
import '../time/data/time_repository.dart';
import '../time/day_summary.dart';
import '../time/entry_edit_sheet.dart';
import '../time/gap_fill_sheet.dart';
import 'routine_widgets.dart';

const _weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

/// Work units per project in the week of [monday].
final projectWeekAeProvider = StreamProvider.autoDispose
    .family<Map<String, int>, DateTime>((ref, monday) {
      final s = ref.watch(currentTimeSettingsProvider);
      return ref
          .watch(timeRepositoryProvider)
          .watchProjectAe(
            monday,
            monday.add(const Duration(days: 7)),
            backgroundWeight: s.backgroundWeight,
            aeMinutes: s.aeMinutes,
          );
    });

/// How a "Zeit prüfen" task is settled.
enum ReviewDecision {
  keepFlatRate('Pauschale bleibt'),
  billExtra('Mehraufwand berechnen'),
  internal('Intern verbuchen');

  const ReviewDecision(this.label);
  final String label;
}

/// Records the decision as a note, makes internal time non-billable and
/// clears the review tag.
Future<void> settleReview(
  WidgetRef ref,
  String taskId,
  ReviewDecision decision,
  String reason,
) async {
  await ref
      .read(notesRepositoryProvider)
      .addText(
        NoteParentType.task,
        taskId,
        'Zeit geprüft: ${decision.label} – ${reason.trim()}',
      );
  if (decision == ReviewDecision.internal) {
    await ref.read(timeRepositoryProvider).setTaskBillable(taskId, false);
  }
  await ref.read(tasksRepositoryProvider).removeTag(taskId, reviewTimeTag);
}

/// Week close: time reviews, open gaps, overnight timers, contingents and
/// project progress.
class WeekCloseScreen extends ConsumerWidget {
  const WeekCloseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final monday = weekStart(today);
    final days = [
      for (var i = 0; i < 5; i++) monday.add(Duration(days: i)),
    ].where((d) => !d.isAfter(today)).toList();
    final reviews = ref.watch(taggedTasksProvider(reviewTimeTag)).value;
    final summaries = [for (final d in days) ref.watch(daySummaryProvider(d))];
    final gapDays = summaries.contains(null)
        ? null
        : [
            for (final s in summaries)
              if (s != null && s.gaps.isNotEmpty) s,
          ];
    final overnight = ref.watch(overnightEntriesProvider(monday)).value;
    final customers = ref
        .watch(allCustomersProvider)
        .value
        ?.where((c) => c.contingentAePerMonth != null)
        .toList();
    final projects = ref
        .watch(projectListProvider(null))
        .value
        ?.where(
          (p) =>
              p.project.status == ProjectStatus.active ||
              p.project.status == ProjectStatus.planned,
        )
        .toList();
    final projectAe =
        ref.watch(projectWeekAeProvider(monday)).value ?? const {};

    return Scaffold(
      appBar: AppBar(title: const Text('Wochenabschluss')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'Woche ab ${formatDate(monday)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RoutineSection(
            title: 'Zeit prüfen',
            count: reviews?.length,
            empty: 'Keine Aufgaben über der Sollzeit.',
            children: [
              for (final v in reviews ?? const <TaskView>[])
                RoutineTaskRow(
                  view: v,
                  actions: [
                    RowAction(
                      'Entscheiden',
                      () => showDialog<void>(
                        context: context,
                        builder: (_) => _ReviewDialog(taskId: v.task.id),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          RoutineSection(
            title: 'Offene Lücken',
            count: gapDays?.length,
            empty: 'Keine offenen Lücken diese Woche.',
            children: [
              for (final s in gapDays ?? const <DaySummary>[])
                ListTile(
                  leading: const Icon(Icons.hourglass_empty),
                  title: Text(
                    '${_weekdays[s.day.weekday - 1]} ${formatDate(s.day)}',
                  ),
                  subtitle: Text(
                    '${s.gaps.length} '
                    '${s.gaps.length == 1 ? 'Lücke' : 'Lücken'} · '
                    '${s.gaps.fold(0, (a, g) => a + g.duration.inMinutes)} min',
                  ),
                  trailing: RowAction(
                    'Nachtragen',
                    () => showGapFillSheet(
                      context,
                      gap: s.gaps.first,
                      dayEntries: s.entries,
                    ),
                  ),
                ),
            ],
          ),
          RoutineSection(
            title: 'Über Nacht gelaufen',
            count: overnight?.length,
            empty: 'Kein Timer lief über Nacht.',
            children: [
              for (final e in overnight ?? const <EntryView>[])
                ListTile(
                  leading: const Icon(Icons.nights_stay_outlined),
                  title: Text(e.title),
                  subtitle: Text(
                    '${_weekdays[e.entry.start.weekday - 1]} '
                    '${formatTime(e.entry.start)} – '
                    '${e.entry.end == null ? 'läuft noch' : '${_weekdays[e.entry.end!.weekday - 1]} ${formatTime(e.entry.end!)}'}',
                  ),
                  trailing: RowAction(
                    'Bearbeiten',
                    () => showEntryEditSheet(context, e),
                  ),
                ),
            ],
          ),
          RoutineSection(
            title: 'Kontingente',
            count: customers?.length,
            empty: 'Kein Kunde mit Kontingent.',
            children: [
              for (final c in customers ?? const <Customer>[])
                _ContingentRow(customer: c),
            ],
          ),
          RoutineSection(
            title: 'Projektfortschritt',
            count: projects?.length,
            empty: 'Keine aktiven Projekte.',
            children: [
              for (final p in projects ?? const <ProjectOverview>[])
                ListTile(
                  title: Text(p.project.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        [
                          if (p.customer != null) p.customer!.name,
                          if (p.milestonesTotal > 0)
                            '${p.milestonesDone}/${p.milestonesTotal} '
                                'Meilensteine',
                          'diese Woche ${projectAe[p.project.id] ?? 0} AE',
                        ].join(' · '),
                      ),
                      if (p.progress != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: LinearProgressIndicator(value: p.progress),
                        ),
                    ],
                  ),
                  onTap: () => context.push('/projects/${p.project.id}'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContingentRow extends ConsumerWidget {
  const _ContingentRow({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final used = ref.watch(customerMonthAeProvider(customer.id)).value;
    final limit = customer.contingentAePerMonth!;
    final share = used == null || limit == 0 ? 0.0 : used / limit;
    final warn = share >= 0.8;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(customer.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            used == null
                ? '… von $limit AE'
                : '$used von $limit AE diesen Monat '
                      '(${(share * 100).round()} %)',
            style: warn ? TextStyle(color: scheme.error) : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: LinearProgressIndicator(
              value: share.clamp(0, 1),
              color: warn ? scheme.error : null,
            ),
          ),
        ],
      ),
      trailing: warn
          ? Icon(
              Icons.warning_amber,
              color: scheme.error,
              semanticLabel: 'Warnung',
            )
          : null,
    );
  }
}

class _ReviewDialog extends ConsumerStatefulWidget {
  const _ReviewDialog({required this.taskId});

  final String taskId;

  @override
  ConsumerState<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends ConsumerState<_ReviewDialog> {
  final _reason = TextEditingController();
  ReviewDecision _decision = ReviewDecision.keepFlatRate;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zeit prüfen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioGroup<ReviewDecision>(
            groupValue: _decision,
            onChanged: (v) => setState(() => _decision = v ?? _decision),
            child: Column(
              children: [
                for (final d in ReviewDecision.values)
                  RadioListTile<ReviewDecision>(
                    contentPadding: EdgeInsets.zero,
                    value: d,
                    title: Text(d.label),
                  ),
              ],
            ),
          ),
          TextField(
            controller: _reason,
            decoration: const InputDecoration(
              labelText: 'Grund',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _reason.text.trim().isEmpty
              ? null
              : () async {
                  await settleReview(
                    ref,
                    widget.taskId,
                    _decision,
                    _reason.text,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
          child: const Text('Übernehmen'),
        ),
      ],
    );
  }
}
