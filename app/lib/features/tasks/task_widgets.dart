import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/formatting.dart';
import '../time/timer_widgets.dart';
import 'data/tasks_repository.dart';
import 'task_actions.dart';

/// Short secondary line for a task: customer/project, checklist, status.
String taskSubtitle(TaskView v, {DateTime? now, bool showCustomer = true}) {
  final t = v.task;
  final parts = <String>[
    if (showCustomer && v.customer != null) v.customer!.name,
    if (v.project != null) v.project!.name,
    if (v.checklistTotal > 0) '${v.checklistDone}/${v.checklistTotal} Schritte',
  ];
  if (v.needsFollowUp(now ?? DateTime.now())) {
    parts.add('Nachfassen bei ${t.waitingFor}');
  } else if (t.status == TaskStatus.waitingFor) {
    parts.add('Wartet auf ${t.waitingFor}');
  } else {
    parts.add(t.status.label);
  }
  if (t.due != null) parts.add('fällig ${formatDate(t.due!)}');
  return parts.join(' · ');
}

class _DoneButton extends ConsumerWidget {
  const _DoneButton(this.view);

  final TaskView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = view.task.status == TaskStatus.done;
    return IconButton(
      tooltip: done ? 'Wieder öffnen' : 'Erledigt',
      icon: Icon(done ? Icons.check_circle : Icons.radio_button_unchecked),
      onPressed: () => done
          ? ref.read(tasksRepositoryProvider).setDone(view.task.id, false)
          : completeTask(context, ref, view.task.id),
    );
  }
}

/// List row with colour bar. Tapping expands the checklist for quick
/// ticking; "Details" opens the full task.
class TaskListItem extends ConsumerStatefulWidget {
  const TaskListItem(this.view, {super.key, this.showCustomer = true});

  final TaskView view;
  final bool showCustomer;

  @override
  ConsumerState<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends ConsumerState<TaskListItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final v = widget.view;
    final t = v.task;
    final color = ColorPalette.resolve(v.color);
    final scheme = Theme.of(context).colorScheme;
    final followUp = v.needsFollowUp(DateTime.now());
    final closed = t.status.isClosed;

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          onLongPress: () => openTask(context, t.id),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            if (t.important)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.priority_high,
                                  size: 18,
                                  color: scheme.error,
                                  semanticLabel: 'Wichtig',
                                ),
                              ),
                            Expanded(
                              child: Text(
                                t.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      decoration: closed
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          taskSubtitle(v, showCustomer: widget.showCustomer),
                          style: TextStyle(
                            color: followUp
                                ? scheme.error
                                : scheme.onSurfaceVariant,
                            fontWeight: followUp ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (closed) _DoneButton(v) else TimerButton(taskId: t.id),
              ],
            ),
          ),
        ),
        if (_expanded) _InlineChecklist(view: v),
        const Divider(height: 1),
      ],
    );
  }
}

class _InlineChecklist extends ConsumerWidget {
  const _InlineChecklist({required this.view});

  final TaskView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(checklistProvider(view.task.id)).value ?? const [];
    final repo = ref.read(tasksRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Keine Checkliste'),
            ),
          for (final i in items)
            CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              value: i.done,
              title: Text(i.required ? '${i.label} (Pflicht)' : i.label),
              onChanged: (v) => repo.setChecklistDone(i, v ?? false),
            ),
          Wrap(
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: () => openTask(context, view.task.id),
                icon: const Icon(Icons.notes),
                label: const Text('Notizen und Details'),
              ),
              if (!view.task.status.isClosed)
                TextButton.icon(
                  onPressed: () => completeTask(context, ref, view.task.id),
                  icon: const Icon(Icons.check),
                  label: const Text('Abschließen'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Coloured tile for the two-column view. Tasks in progress are filled
/// with their colour.
class TaskTileCard extends ConsumerWidget {
  const TaskTileCard(this.view, {super.key});

  final TaskView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = view.task;
    final color = ColorPalette.resolve(view.color);
    final active = ref.watch(runningTaskIdsProvider).contains(t.id);
    final scheme = Theme.of(context).colorScheme;
    final fg = active ? ColorPalette.onColor(color) : scheme.onSurface;
    final progress = view.checklistTotal == 0
        ? null
        : view.checklistDone / view.checklistTotal;

    return Card(
      color: active ? color : color.withValues(alpha: 0.10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: t.status.isClosed
            ? () => openTask(context, t.id)
            : () => toggleTimer(context, ref, t.id, running: active),
        onLongPress: () => openTask(context, t.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: active ? fg : color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      active ? 'Läuft' : t.status.label,
                      style: TextStyle(color: fg, fontSize: 12),
                    ),
                  ),
                  if (!t.status.isClosed)
                    Icon(
                      active ? Icons.pause : Icons.play_arrow,
                      size: 18,
                      color: fg,
                    ),
                  if (t.important)
                    Icon(
                      Icons.priority_high,
                      size: 16,
                      color: fg,
                      semanticLabel: 'Wichtig',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  t.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              if (view.customer != null)
                Text(
                  view.customer!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: fg, fontSize: 12),
                ),
              if (progress != null) ...[
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progress,
                  color: active ? fg : color,
                  backgroundColor: (active ? fg : color).withValues(alpha: 0.2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
