import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/color_palette.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/task_actions.dart';
import '../tasks/task_widgets.dart';
import '../time/data/time_repository.dart';
import '../time/day_summary.dart';
import '../time/engine/time_math.dart';
import '../time/timer_widgets.dart';

/// What Jetzt shows about a task, shared by tiles and list rows.
class _FocusInfo {
  _FocusInfo(this.view, this.running, this.summary);

  final TaskView view;
  final EntryView? running;
  final DaySummary? summary;

  Task get task => view.task;
  bool get isRunning => running != null;
  String get customer => view.customer?.name ?? 'Kein Kunde';
  Color get color => ColorPalette.resolve(view.color);
  Duration get today => summary?.rawByTask[task.id] ?? Duration.zero;

  /// Live time for running tasks (with seconds), h:mm otherwise.
  String get time => isRunning ? formatHms(today) : formatHm(today);

  String get runningDetail {
    if (view.checklistTotal > 0) {
      return 'Schritt ${view.checklistDone}/${view.checklistTotal}';
    }
    return running?.entry.kind == TimeEntryKind.background
        ? 'nebenher'
        : 'aktiv';
  }

  bool get followUp => view.needsFollowUp(DateTime.now());

  String get idleHint {
    if (followUp) return 'Nachfassen bei ${task.waitingFor}';
    if (task.status == TaskStatus.inProgress) {
      return today > Duration.zero
          ? 'Pausiert · ${formatHm(today)}'
          : 'Pausiert';
    }
    return 'Antippen zum Starten';
  }
}

TextStyle _timeStyle(Color color, double size) => TextStyle(
  color: color,
  fontSize: size,
  fontWeight: FontWeight.w700,
  fontFeatures: const [FontFeature.tabularFigures()],
);

/// Compact tile on Jetzt. Running tasks are filled with their colour and
/// show live time, pause and "Fertig"; others start on tap.
class FocusCard extends ConsumerWidget {
  const FocusCard({
    super.key,
    required this.view,
    required this.running,
    required this.summary,
  });

  final TaskView view;
  final EntryView? running;
  final DaySummary? summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i = _FocusInfo(view, running, summary);
    final scheme = Theme.of(context).colorScheme;
    final t = i.task;

    if (i.isRunning) {
      final on = ColorPalette.onColor(i.color);
      return Material(
        color: i.color,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => openTask(context, t.id),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  i.customer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: on,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  t.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: on,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                if (view.checklistTotal > 0)
                  _ChecklistChip(view: view, color: on)
                else
                  Text(
                    i.runningDetail,
                    style: TextStyle(
                      color: on.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                const Spacer(),
                Text(i.time, style: _timeStyle(on, 22)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _PauseButton(taskId: t.id, color: on),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _DoneButton(taskId: t.id, base: i.color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => toggleTimer(context, ref, t.id, running: false),
        onLongPress: () => openTask(context, t.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Dot(i.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      i.customer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: view.color == null
                            ? scheme.onSurfaceVariant
                            : i.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (view.checklistTotal > 0)
                    _ChecklistChip(view: view, color: scheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                t.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              _IdleHint(info: i),
            ],
          ),
        ),
      ),
    );
  }
}

/// Slim list row for Jetzt. The chevron unfolds the checklist.
class FocusRow extends ConsumerStatefulWidget {
  const FocusRow({
    super.key,
    required this.view,
    required this.running,
    required this.summary,
  });

  final TaskView view;
  final EntryView? running;
  final DaySummary? summary;

  @override
  ConsumerState<FocusRow> createState() => _FocusRowState();
}

class _FocusRowState extends ConsumerState<FocusRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final view = widget.view;
    final scheme = Theme.of(context).colorScheme;
    final row = _row(context);
    if (!_expanded) return row;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row,
        // Material (not a decorated box) so the checklist tiles show their
        // ink on the card background.
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Material(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: InlineChecklist(view: view),
          ),
        ),
      ],
    );
  }

  Widget? _chevron(Color color) {
    if (widget.view.checklistTotal == 0) return null;
    return IconButton(
      tooltip: _expanded ? 'Checkliste zuklappen' : 'Checkliste aufklappen',
      color: color,
      visualDensity: VisualDensity.compact,
      icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
      onPressed: () => setState(() => _expanded = !_expanded),
    );
  }

  Widget _row(BuildContext context) {
    final view = widget.view;
    final i = _FocusInfo(view, widget.running, widget.summary);
    final scheme = Theme.of(context).colorScheme;
    final t = i.task;

    if (i.isRunning) {
      final on = ColorPalette.onColor(i.color);
      final chevron = _chevron(on);
      return Material(
        color: i.color,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => openTask(context, t.id),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: on,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${i.customer} · ${i.runningDetail}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: on, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ?chevron,
                Text(i.time, style: _timeStyle(on, 17)),
                const SizedBox(width: 4),
                _PauseButton(taskId: t.id, color: on),
                const SizedBox(width: 4),
                _DoneButton(taskId: t.id, base: i.color),
              ],
            ),
          ),
        ),
      );
    }

    final chevron = _chevron(scheme.onSurfaceVariant);
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => toggleTimer(context, ref, t.id, running: false),
        onLongPress: () => openTask(context, t.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
          child: Row(
            children: [
              _Dot(i.color),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${i.customer} · ${i.idleHint}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: i.followUp
                            ? scheme.error
                            : scheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ?chevron,
              Icon(Icons.play_arrow_outlined, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// "☑ 1/3" on a tile; opens the checklist in a sheet.
class _ChecklistChip extends StatelessWidget {
  const _ChecklistChip({required this.view, required this.color});

  final TaskView view;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => showChecklistSheet(context, view),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist, size: 16, color: color),
            const SizedBox(width: 3),
            Text(
              '${view.checklistDone}/${view.checklistTotal}',
              semanticsLabel:
                  'Checkliste ${view.checklistDone} von ${view.checklistTotal}',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a task's checklist in a bottom sheet.
Future<void> showChecklistSheet(BuildContext context, TaskView view) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                view.task.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            InlineChecklist(view: view),
          ],
        ),
      ),
    ),
  );
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _IdleHint extends StatelessWidget {
  const _IdleHint({required this.info});

  final _FocusInfo info;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = info.followUp ? scheme.error : scheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(
          info.followUp
              ? Icons.notification_important
              : Icons.play_arrow_outlined,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            info.idleHint,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _PauseButton extends ConsumerWidget {
  const _PauseButton({required this.taskId, required this.color});

  final String taskId;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton.filledTonal(
        tooltip: 'Timer pausieren',
        style: IconButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.14),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.pause),
        onPressed: () => toggleTimer(context, ref, taskId, running: true),
      ),
    );
  }
}

class _DoneButton extends ConsumerWidget {
  const _DoneButton({required this.taskId, required this.base});

  final String taskId;
  final Color base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 44,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: Color.alphaBlend(
            Colors.black.withValues(alpha: 0.75),
            base,
          ),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => completeTask(context, ref, taskId),
        child: const Text(
          'Fertig',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
