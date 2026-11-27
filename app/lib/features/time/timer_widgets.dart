import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../../core/settings/time_settings.dart';
import '../../core/ui/color_palette.dart';
import '../tasks/task_actions.dart';
import 'data/time_repository.dart';
import 'day_summary.dart';
import 'engine/time_math.dart';

/// Starts or pauses the timer of [taskId]. After pausing, offers to resume
/// the timers that were paused when it started.
Future<void> toggleTimer(
  BuildContext context,
  WidgetRef ref,
  String taskId, {
  required bool running,
}) async {
  final repo = ref.read(timeRepositoryProvider);
  if (!running) {
    // Timers run in parallel; nothing else is paused.
    await repo.start(taskId);
    return;
  }
  final toResume = await repo.pause(taskId);
  if (toResume.isEmpty || !context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          toResume.length == 1
              ? 'Pausierten Timer fortsetzen?'
              : '${toResume.length} pausierte Timer fortsetzen?',
        ),
        duration: const Duration(seconds: 8),
        action: SnackBarAction(
          label: 'Fortsetzen',
          onPressed: () => repo.resume(toResume),
        ),
      ),
    );
}

/// Asks whether running active timers should pause while a quick-start
/// timer runs. Returns null if cancelled; no question if nothing runs.
Future<bool?> askPauseOthers(BuildContext context, WidgetRef ref) async {
  final running = await ref.read(timeRepositoryProvider).watchRunning().first;
  final active = running
      .where((r) => r.entry.kind == TimeEntryKind.active)
      .toList();
  if (active.isEmpty || !context.mounted) return false;
  final preferPause = ref.read(currentTimeSettingsProvider).pauseOthers;
  final names = active.map((r) => '• ${r.title}').join('\n');
  return showDialog<bool>(
    context: context,
    builder: (context) {
      final pauseButton = preferPause ? FilledButton.new : TextButton.new;
      final parallelButton = preferPause ? TextButton.new : FilledButton.new;
      return AlertDialog(
        title: const Text('Andere Timer pausieren?'),
        content: Text(
          'Es laufen:\n$names\n\nSollen sie für diesen Zeitraum pausieren? '
          'Danach kannst du sie mit einem Tipp fortsetzen.',
        ),
        actions: [
          parallelButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Weiterlaufen lassen'),
          ),
          pauseButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Pausieren'),
          ),
        ],
      );
    },
  );
}

/// Ids of tasks whose timer is currently running.
final runningTaskIdsProvider = Provider.autoDispose<Set<String>>((ref) {
  final running = ref.watch(runningTimersProvider).value ?? const [];
  return {
    for (final e in running)
      if (e.entry.taskId != null) e.entry.taskId!,
  };
});

class TimerButton extends ConsumerWidget {
  const TimerButton({super.key, required this.taskId, this.color});

  final String taskId;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running = ref.watch(runningTaskIdsProvider).contains(taskId);
    return IconButton(
      tooltip: running ? 'Timer pausieren' : 'Timer starten',
      color: color,
      icon: Icon(running ? Icons.pause_circle : Icons.play_circle_outline),
      iconSize: 32,
      onPressed: () => toggleTimer(context, ref, taskId, running: running),
    );
  }
}

class QuickStartBar extends ConsumerWidget {
  const QuickStartBar({super.key});

  static const _icons = {
    QuickStartKind.remote: Icons.screen_share_outlined,
    QuickStartKind.phone: Icons.call_outlined,
    QuickStartKind.onSite: Icons.directions_car_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget button(IconData icon, String label, VoidCallback onTap) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            minimumSize: const Size(0, 56),
          ),
          onPressed: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          for (final k in QuickStartKind.values)
            button(_icons[k]!, k.label, () async {
              final pauseOthers = await askPauseOthers(context, ref);
              if (pauseOthers == null) return;
              await ref
                  .read(timeRepositoryProvider)
                  .quickStart(k, pauseOthers: pauseOthers);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('${k.label} läuft – Kunde später zuordnen'),
                  ),
                );
            }),
          button(
            Icons.more_horiz,
            'Mehr',
            () => context.push('${AppRoutes.now}/start'),
          ),
        ],
      ),
    );
  }
}

/// Card for a running timer: title, customer, live time today, kind switch
/// and pause.
class RunningTimerCard extends ConsumerWidget {
  const RunningTimerCard({
    super.key,
    required this.view,
    required this.summary,
  });

  final EntryView view;
  final DaySummary? summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ColorPalette.resolve(view.color);
    final onColor = ColorPalette.onColor(color);
    final taskId = view.entry.taskId;
    final now = ref.watch(currentNowProvider);
    final segment = now.difference(view.entry.start);
    final today = summary?.bucketFor(view) ?? segment;
    final background = view.entry.kind == TimeEntryKind.background;

    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: taskId == null ? null : () => openTask(context, taskId),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      view.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      [
                        view.customer?.name ?? 'Kein Kunde',
                        if (background) 'nebenher',
                        'heute ${formatHm(today)}',
                        '${roundUpAe(today, aeMinutes: summary?.aeMinutes ?? 10)} AE',
                      ].join(' · '),
                      style: TextStyle(color: onColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                formatHms(segment.isNegative ? Duration.zero : segment),
                style: TextStyle(
                  color: onColor,
                  fontSize: 18,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (taskId != null) ...[
                IconButton(
                  tooltip: background
                      ? 'Nebenher – auf aktiv umstellen'
                      : 'Aktiv – auf nebenher umstellen',
                  color: onColor,
                  icon: Icon(
                    background ? Icons.layers_outlined : Icons.person_outline,
                  ),
                  onPressed: () => ref
                      .read(timeRepositoryProvider)
                      .setKind(
                        taskId,
                        background
                            ? TimeEntryKind.active
                            : TimeEntryKind.background,
                      ),
                ),
                IconButton(
                  tooltip: 'Timer pausieren',
                  color: onColor,
                  icon: const Icon(Icons.pause_circle),
                  iconSize: 32,
                  onPressed: () =>
                      toggleTimer(context, ref, taskId, running: true),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
