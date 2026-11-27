import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../tasks/data/tasks_repository.dart';
import '../time/data/time_repository.dart';
import '../time/day_summary.dart';
import '../time/gap_fill_sheet.dart' show formatTime;
import 'routine_widgets.dart';

/// Morning planning: clear the inbox, see today's appointments, take over
/// what was left, follow-ups, and set the order for the day.
class MorningScreen extends ConsumerStatefulWidget {
  const MorningScreen({super.key});

  @override
  ConsumerState<MorningScreen> createState() => _MorningScreenState();
}

class _MorningScreenState extends ConsumerState<MorningScreen> {
  /// Optimistic order while the database catches up.
  List<String>? _order;

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayProvider);
    final tomorrow = today.add(const Duration(days: 1));
    final repo = tasksRepo(ref);
    final inbox = ref.watch(inboxTasksProvider).value;
    final appointments = ref.watch(dayAppointmentsProvider(today)).value;
    final overdue = ref.watch(overdueTasksProvider(today)).value;
    final followUps = ref.watch(followUpsDueProvider(today)).value;
    final planned = ref
        .watch(plannedOnProvider(today))
        .value
        ?.where((v) => !isAppointment(v.task))
        .toList();
    final clock = ref.watch(dayClockProvider(today)).value;

    final ordered = planned == null
        ? null
        : _order == null
        ? planned
        : [
            for (final id in _order!) ...planned.where((v) => v.task.id == id),
            ...planned.where((v) => !_order!.contains(v.task.id)),
          ];

    return Scaffold(
      appBar: AppBar(title: const Text('Morgenplanung')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          RoutineSection(
            title: 'Eingang',
            count: inbox?.length,
            empty: 'Eingang ist leer.',
            children: [
              for (final v in inbox ?? const <TaskView>[])
                RoutineTaskRow(
                  view: v,
                  actions: [
                    RowAction('Heute', () => repo.planFor(v.task.id, today)),
                    RowAction('Später', () => repo.moveToSomeday(v.task.id)),
                  ],
                ),
            ],
          ),
          RoutineSection(
            title: 'Termine heute',
            count: appointments?.length,
            empty: 'Keine Termine heute.',
            children: [
              for (final v in appointments ?? const <TaskView>[])
                RoutineTaskRow(
                  view: v,
                  subtitle:
                      '${formatTime(v.task.plannedDay!)} Uhr'
                      '${v.customer == null ? '' : ' · ${v.customer!.name}'}',
                ),
            ],
          ),
          RoutineSection(
            title: 'Liegengeblieben',
            count: overdue?.length,
            empty: 'Nichts liegengeblieben.',
            trailing: TextButton(
              onPressed: () async {
                for (final v in overdue ?? const <TaskView>[]) {
                  await repo.planFor(v.task.id, today);
                }
              },
              child: const Text('Alle übernehmen'),
            ),
            children: [
              for (final v in overdue ?? const <TaskView>[])
                RoutineTaskRow(
                  view: v,
                  actions: [
                    RowAction('Heute', () => repo.planFor(v.task.id, today)),
                    RowAction(
                      'Irgendwann',
                      () => repo.moveToSomeday(v.task.id),
                    ),
                  ],
                ),
            ],
          ),
          RoutineSection(
            title: 'Nachfassen',
            count: followUps?.length,
            empty: 'Heute nichts nachzufassen.',
            children: [
              for (final v in followUps ?? const <TaskView>[])
                RoutineTaskRow(
                  view: v,
                  subtitle: 'Bei ${v.task.waitingFor ?? '–'}',
                  actions: [
                    RowAction(
                      'Morgen',
                      () => repo.saveTask(
                        TasksCompanion(
                          id: Value(v.task.id),
                          followUpDate: Value(tomorrow),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          RoutineSection(
            title: 'Reihenfolge heute',
            count: ordered?.length,
            empty: 'Noch nichts für heute geplant.',
            children: [
              if (ordered != null)
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorder: (from, to) {
                    final ids = ordered.map((v) => v.task.id).toList();
                    final id = ids.removeAt(from);
                    ids.insert(to > from ? to - 1 : to, id);
                    setState(() => _order = ids);
                    repo.setOrder(ids);
                  },
                  children: [
                    for (final (i, v) in ordered.indexed)
                      RoutineTaskRow(
                        key: ValueKey(v.task.id),
                        view: v,
                        leading: CircleAvatar(
                          radius: 12,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        actions: [
                          ReorderableDragStartListener(
                            index: i,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.drag_handle,
                                semanticLabel: 'Verschieben',
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: FilledButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: Text(clock == null ? 'Tag starten' : 'Zu Jetzt'),
              onPressed: () async {
                if (clock == null) {
                  await ref.read(timeRepositoryProvider).startDay();
                }
                if (context.mounted) context.go(AppRoutes.now);
              },
            ),
          ),
        ],
      ),
    );
  }
}
