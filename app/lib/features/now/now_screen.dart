import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/settings/time_settings.dart';
import '../../core/settings/view_settings.dart';
import '../../core/ui/formatting.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/quick_capture_sheet.dart';
import '../tasks/task_actions.dart';
import '../time/data/time_repository.dart';
import '../time/day_summary.dart';
import '../time/gap_fill_sheet.dart' show formatTime;
import '../time/engine/time_math.dart' show formatHm;
import '../time/timer_widgets.dart';
import 'focus_card.dart';
import 'now_day_header.dart';

/// Focused view: what is running, what is paused or planned for today,
/// and what comes next. Everything else lives under Aufgaben.
class NowScreen extends ConsumerWidget {
  const NowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final running = ref.watch(runningTimersProvider).value ?? const [];
    final focus = ref.watch(focusTasksProvider(today)).value ?? const [];
    final summary = ref.watch(daySummaryProvider(today));
    final settings = ref.watch(currentTimeSettingsProvider);
    final now = ref.watch(currentNowProvider);
    final layout = ref.watch(jetztViewProvider).value ?? NowView.tiles;
    final textTheme = Theme.of(context).textTheme;

    final runningByTask = {
      for (final r in running)
        if (r.entry.taskId != null) r.entry.taskId!: r,
    };
    // Appointments later today wait in the bar at the bottom until their
    // time has come (unless already started).
    bool waiting(TaskView v) =>
        isAppointment(v.task) &&
        v.task.plannedDay!.isAfter(now) &&
        v.task.status != TaskStatus.inProgress &&
        !runningByTask.containsKey(v.task.id);
    final upcomingToday = focus.where(waiting).toList()
      ..sort((a, b) => a.task.plannedDay!.compareTo(b.task.plannedDay!));
    // Running first (in start order), then paused, then planned.
    final cards = focus.where((v) => !waiting(v)).toList()
      ..sort((a, b) {
        int rank(TaskView v) {
          if (runningByTask.containsKey(v.task.id)) return 0;
          if (v.task.status == TaskStatus.inProgress) return 1;
          return 2;
        }

        final r = rank(a).compareTo(rank(b));
        if (r != 0) return r;
        final ra = runningByTask[a.task.id]?.entry.start;
        final rb = runningByTask[b.task.id]?.entry.start;
        if (ra != null && rb != null) return ra.compareTo(rb);
        return 0;
      });
    // Running timers without a matching card (e.g. task filtered out).
    final cardIds = {for (final c in cards) c.task.id};
    final orphanRunning = running
        .where(
          (r) => r.entry.taskId == null || !cardIds.contains(r.entry.taskId),
        )
        .toList();

    final count = running.length;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  const NowDayHeader(showingDay: false),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          count == 0 ? 'Nichts läuft' : '$count laufen',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        'Arbeitszeit ${formatHm(summary?.worked ?? Duration.zero)}',
                        style: textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      IconButton(
                        tooltip: layout == NowView.tiles
                            ? 'Als Liste anzeigen'
                            : 'Als Kacheln anzeigen',
                        icon: Icon(
                          layout == NowView.tiles
                              ? Icons.view_list
                              : Icons.grid_view,
                        ),
                        onPressed: () => ref
                            .read(jetztViewProvider.notifier)
                            .set(
                              layout == NowView.tiles
                                  ? NowView.list
                                  : NowView.tiles,
                            ),
                      ),
                    ],
                  ),
                  if (settings.quickStartEnabled) ...[
                    const SizedBox(height: 12),
                    const QuickStartBar(),
                  ],
                  const SizedBox(height: 16),
                  for (final r in orphanRunning)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RunningTimerCard(view: r, summary: summary),
                    ),
                  if (layout == NowView.tiles)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            mainAxisExtent: 190,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: cards.length,
                      itemBuilder: (_, i) => FocusCard(
                        key: ValueKey(cards[i].task.id),
                        view: cards[i],
                        running: runningByTask[cards[i].task.id],
                        summary: summary,
                      ),
                    )
                  else
                    for (final c in cards)
                      Padding(
                        key: ValueKey(c.task.id),
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FocusRow(
                          view: c,
                          running: runningByTask[c.task.id],
                          summary: summary,
                        ),
                      ),
                  const SizedBox(height: 12),
                  _NewTaskButton(
                    onTap: () => showQuickCapture(context, planToday: true),
                  ),
                ],
              ),
            ),
            _NextUpBar(
              today: today,
              now: now,
              upcomingToday: upcomingToday.isEmpty ? null : upcomingToday.first,
            ),
          ],
        ),
      ),
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  const _NewTaskButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: scheme.outline),
        child: const SizedBox(
          height: 72,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 12),
                Text(
                  'Neue Aufgabe',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24)),
      );
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), paint);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}

class _NextUpBar extends ConsumerWidget {
  const _NextUpBar({
    required this.today,
    required this.now,
    required this.upcomingToday,
  });

  final DateTime today;
  final DateTime now;

  /// The next appointment later today, if any.
  final TaskView? upcomingToday;

  String _when(DateTime date) {
    if (DateTime(date.year, date.month, date.day) == today) {
      final minutes = date.difference(now).inMinutes;
      if (minutes < 60) return 'in ${minutes < 1 ? 1 : minutes} min';
      return 'um ${formatTime(date)}';
    }
    final days = DateTime(
      date.year,
      date.month,
      date.day,
    ).difference(today).inDays;
    final hasTime = date.hour != 0 || date.minute != 0;
    final time = hasTime ? ' ${formatTime(date)}' : '';
    if (days <= 1) return 'morgen$time';
    if (days < 7) {
      const names = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
      return '${names[date.weekday - 1]} ${formatDate(date).substring(0, 6)}$time';
    }
    return '${formatDate(date)}$time';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = upcomingToday ?? ref.watch(nextUpProvider(today)).value;
    final scheme = Theme.of(context).colorScheme;
    final date = next?.task.plannedDay ?? next?.task.due;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: next == null ? null : () => openTask(context, next.task.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.event_outlined, color: scheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: next == null
                      ? Text(
                          'Nichts weiter geplant',
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        )
                      : Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${_when(date!)} · ',
                                style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              TextSpan(
                                text: next.task.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
