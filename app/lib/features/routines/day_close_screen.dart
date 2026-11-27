import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tasks/data/tasks_repository.dart';
import '../time/data/time_repository.dart';
import '../time/day_summary.dart';
import '../time/engine/time_math.dart';
import '../time/entry_edit_sheet.dart';
import '../time/gap_fill_sheet.dart';
import 'routine_widgets.dart';

/// Day close: assign gaps, stop timers, move what is left, see what got
/// done, and end the working day.
class DayCloseScreen extends ConsumerWidget {
  const DayCloseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final tomorrow = today.add(const Duration(days: 1));
    final repo = tasksRepo(ref);
    final time = ref.read(timeRepositoryProvider);
    final summary = ref.watch(daySummaryProvider(today));
    final running = ref.watch(runningTimersProvider).value;
    final open = ref.watch(plannedOnProvider(today)).value;
    final done = ref.watch(doneOnProvider(today)).value;
    final clock = ref.watch(dayClockProvider(today)).value;
    final clockRunning = clock != null && !clock.isEnded;

    return Scaffold(
      appBar: AppBar(title: const Text('Tagesabschluss')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          if (summary != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                'Heute ${summary.ae} AE · ${formatHm(summary.recorded)} h '
                'erfasst · ${formatHm(summary.worked)} h Arbeitszeit',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          RoutineSection(
            title: 'Lücken',
            count: summary?.gaps.length,
            empty: 'Keine offenen Lücken.',
            children: [
              for (final g in summary?.gaps ?? const <TimeSpan>[])
                ListTile(
                  leading: const Icon(Icons.hourglass_empty),
                  title: Text(
                    '${formatTime(g.start)}–${formatTime(g.end)} · '
                    '${g.duration.inMinutes} min',
                  ),
                  trailing: RowAction(
                    'Nachtragen',
                    () => showGapFillSheet(
                      context,
                      gap: g,
                      dayEntries: summary!.entries,
                    ),
                  ),
                ),
            ],
          ),
          RoutineSection(
            title: 'Laufende Timer',
            count: running?.length,
            empty: 'Kein Timer läuft.',
            children: [
              for (final e in running ?? const <EntryView>[])
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: Text(e.title),
                  subtitle: Text('seit ${formatTime(e.entry.start)}'),
                  trailing: e.task == null
                      ? RowAction(
                          'Bearbeiten',
                          () => showEntryEditSheet(context, e),
                        )
                      : RowAction('Pausieren', () => time.pause(e.task!.id)),
                ),
            ],
          ),
          RoutineSection(
            title: 'Offen von heute',
            count: open?.length,
            empty: 'Alles für heute erledigt.',
            trailing: TextButton(
              onPressed: () async {
                for (final v in open ?? const <TaskView>[]) {
                  await repo.planFor(v.task.id, tomorrow);
                }
              },
              child: const Text('Alle auf morgen'),
            ),
            children: [
              for (final v in open ?? const <TaskView>[])
                RoutineTaskRow(
                  view: v,
                  actions: [
                    RowAction(
                      'Morgen',
                      () => repo.planFor(v.task.id, tomorrow),
                    ),
                    RowAction(
                      'Irgendwann',
                      () => repo.moveToSomeday(v.task.id),
                    ),
                  ],
                ),
            ],
          ),
          RoutineSection(
            title: 'Erledigt heute',
            count: done?.length,
            empty: 'Heute noch nichts abgeschlossen.',
            children: [
              for (final v in done ?? const <TaskView>[])
                RoutineTaskRow(
                  view: v,
                  leading: Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: FilledButton.icon(
              icon: const Icon(Icons.logout),
              label: Text(
                clockRunning ? 'Feierabend' : 'Arbeitsuhr läuft nicht',
              ),
              onPressed: clockRunning
                  ? () async {
                      await time.endClock();
                      if (context.mounted) {
                        routineSnack(
                          context,
                          'Feierabend! Timer und Arbeitsuhr sind gestoppt.',
                        );
                        Navigator.of(context).maybePop();
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
