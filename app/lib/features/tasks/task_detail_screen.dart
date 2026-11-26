import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/formatting.dart';
import 'data/tasks_repository.dart';
import 'task_actions.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskProvider(taskId));
    return task.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Fehler: $e'))),
      data: (v) => v == null
          ? Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                icon: Icons.task_alt,
                message: 'Aufgabe nicht gefunden.',
              ),
            )
          : _TaskDetail(view: v),
    );
  }
}

/// Statuses that can be set directly without extra input.
const _quickStatuses = [
  TaskStatus.inbox,
  TaskStatus.planned,
  TaskStatus.inProgress,
  TaskStatus.blocked,
  TaskStatus.someday,
  TaskStatus.dropped,
];

Future<(String, bool)?> _askChecklistItem(BuildContext context) {
  final controller = TextEditingController();
  var required = false;
  return showDialog<(String, bool)>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        void submit() {
          final text = controller.text.trim();
          Navigator.pop(context, text.isEmpty ? null : (text, required));
        }

        return AlertDialog(
          title: const Text('Neuer Schritt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Schritt',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => submit(),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Pflichtschritt'),
                value: required,
                onChanged: (v) => setState(() => required = v ?? false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            FilledButton(onPressed: submit, child: const Text('Hinzufügen')),
          ],
        );
      },
    ),
  ).whenComplete(controller.dispose);
}

class _TaskDetail extends ConsumerWidget {
  const _TaskDetail({required this.view});

  final TaskView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = view.task;
    final repo = ref.read(tasksRepositoryProvider);
    final checklist = ref.watch(checklistProvider(t.id));
    final color = ColorPalette.resolve(view.color);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final done = t.status == TaskStatus.done;
    final followUp = view.needsFollowUp(DateTime.now());

    final info = <(IconData, String)>[
      if (view.customer != null) (Icons.business_outlined, view.customer!.name),
      if (view.project != null) (Icons.folder_outlined, view.project!.name),
      if (t.plannedDay != null)
        (Icons.today_outlined, 'Geplant für ${formatDate(t.plannedDay!)}'),
      if (t.due != null) (Icons.event_outlined, 'Fällig ${formatDate(t.due!)}'),
      if (t.estimateMin != null)
        (Icons.timer_outlined, 'Schätzung ${t.estimateMin} min'),
      if (t.source != null) (Icons.input, 'Quelle: ${t.source!.label}'),
      if (t.status == TaskStatus.waitingFor)
        (
          Icons.hourglass_empty,
          'Wartet auf ${t.waitingFor}'
              '${t.waitingSince == null ? '' : ' seit ${formatDate(t.waitingSince!)}'}'
              '${t.followUpDate == null ? '' : ' · nachfassen am ${formatDate(t.followUpDate!)}'}',
        ),
      if (view.tags.isNotEmpty) (Icons.label_outline, view.tags.join(', ')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aufgabe'),
        actions: [
          IconButton(
            tooltip: 'Bearbeiten',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('${taskRoute(t.id)}/edit'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: done
              ? OutlinedButton.icon(
                  onPressed: () => repo.setDone(t.id, false),
                  icon: const Icon(Icons.undo),
                  label: const Text('Wieder öffnen'),
                )
              : FilledButton.icon(
                  onPressed: () => completeTask(context, ref, t.id),
                  icon: const Icon(Icons.check),
                  label: const Text('Abschließen'),
                ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(t.title, style: textTheme.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: [
                PopupMenuButton<TaskStatus>(
                  tooltip: 'Status ändern',
                  onSelected: (s) => repo.setStatus(t.id, s),
                  itemBuilder: (_) => [
                    for (final s in _quickStatuses)
                      PopupMenuItem(value: s, child: Text(s.label)),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.flag_outlined, size: 18),
                    label: Text(t.status.label),
                  ),
                ),
                if (t.important)
                  Chip(
                    avatar: Icon(
                      Icons.priority_high,
                      size: 18,
                      color: scheme.error,
                    ),
                    label: const Text('Wichtig'),
                  ),
                if (followUp)
                  Chip(
                    avatar: Icon(
                      Icons.notification_important,
                      size: 18,
                      color: scheme.error,
                    ),
                    label: const Text('Nachfassen fällig'),
                  ),
              ],
            ),
          ),
          for (final (icon, text) in info)
            ListTile(dense: true, leading: Icon(icon), title: Text(text)),
          SectionHeader(
            'Checkliste',
            trailing: IconButton(
              tooltip: 'Schritt hinzufügen',
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await _askChecklistItem(context);
                if (result != null) {
                  await repo.addChecklistItem(
                    t.id,
                    result.$1,
                    required: result.$2,
                  );
                }
              },
            ),
          ),
          checklist.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Fehler: $e'),
            data: (items) => items.isEmpty
                ? const ListTile(title: Text('Noch keine Schritte'))
                : ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    onReorder: (oldIndex, newIndex) {
                      final ids = items.map((i) => i.id).toList();
                      if (newIndex > oldIndex) newIndex--;
                      ids.insert(newIndex, ids.removeAt(oldIndex));
                      repo.reorderChecklist(t.id, ids);
                    },
                    children: [
                      for (final (index, item) in items.indexed)
                        _ChecklistRow(
                          key: ValueKey(item.id),
                          item: item,
                          index: index,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends ConsumerWidget {
  const _ChecklistRow({super.key, required this.item, required this.index});

  final ChecklistItem item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(tasksRepositoryProvider);
    return ListTile(
      leading: Checkbox(
        value: item.done,
        onChanged: (v) => repo.setChecklistDone(item, v ?? false),
      ),
      title: Text(
        item.label,
        style: item.done
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: item.required ? const Text('Pflicht') : null,
      onTap: () => repo.setChecklistDone(item, !item.done),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton<String>(
            tooltip: 'Mehr',
            onSelected: (action) => switch (action) {
              'required' => repo.setChecklistRequired(item, !item.required),
              _ => repo.deleteChecklistItem(item),
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'required',
                child: Text(
                  item.required
                      ? 'Kein Pflichtschritt'
                      : 'Als Pflicht markieren',
                ),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Löschen')),
            ],
          ),
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.drag_handle),
            ),
          ),
        ],
      ),
    );
  }
}
