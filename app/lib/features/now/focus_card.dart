import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/color_palette.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/task_actions.dart';
import '../time/data/time_repository.dart';
import '../time/day_summary.dart';
import '../time/engine/time_math.dart';
import '../time/timer_widgets.dart';

/// Card on Jetzt. Running tasks are filled with their colour and show the
/// time today, pause and "Fertig". Others are tapped to start.
class FocusCard extends ConsumerWidget {
  const FocusCard({
    super.key,
    required this.view,
    required this.running,
    required this.summary,
  });

  final TaskView view;

  /// The running entry of this task, if any.
  final EntryView? running;
  final DaySummary? summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = view.task;
    final color = ColorPalette.resolve(view.color);
    final scheme = Theme.of(context).colorScheme;
    final isRunning = running != null;
    final today = summary?.rawByTask[t.id] ?? Duration.zero;
    final customer = view.customer?.name ?? 'Kein Kunde';

    if (isRunning) {
      final on = ColorPalette.onColor(color);
      final background = running!.entry.kind == TimeEntryKind.background;
      final detail = view.checklistTotal > 0
          ? 'Schritt ${view.checklistDone}/${view.checklistTotal}'
          : background
          ? 'nebenher'
          : 'aktiv';
      return Material(
        color: color,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => openTask(context, t.id),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: on,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: on,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    color: on.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  formatHm(today),
                  style: TextStyle(
                    color: on,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 44,
                      child: IconButton.filledTonal(
                        tooltip: 'Timer pausieren',
                        style: IconButton.styleFrom(
                          backgroundColor: on.withValues(alpha: 0.12),
                          foregroundColor: on,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.pause),
                        onPressed: () =>
                            toggleTimer(context, ref, t.id, running: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Color.alphaBlend(
                              Colors.black.withValues(alpha: 0.75),
                              color,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => completeTask(context, ref, t.id),
                          child: const Text(
                            'Fertig',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    final paused = t.status == TaskStatus.inProgress;
    final followUp = view.needsFollowUp(DateTime.now());
    final hint = followUp
        ? 'Nachfassen bei ${t.waitingFor}'
        : paused
        ? today > Duration.zero
              ? 'Pausiert · ${formatHm(today)} – antippen zum Fortsetzen'
              : 'Pausiert – antippen zum Fortsetzen'
        : 'Antippen zum Starten';
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => toggleTimer(context, ref, t.id, running: false),
        onLongPress: () => openTask(context, t.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      customer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: view.color == null
                            ? scheme.onSurfaceVariant
                            : color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                t.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    followUp
                        ? Icons.notification_important
                        : Icons.play_arrow_outlined,
                    size: 18,
                    color: followUp ? scheme.error : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hint,
                      style: TextStyle(
                        color: followUp
                            ? scheme.error
                            : scheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
