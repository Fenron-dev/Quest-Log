import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/formatting.dart';
import '../../core/ui/text_prompt_dialog.dart';
import 'data/projects_repository.dart';
import 'project_tile.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/quick_capture_sheet.dart';
import '../tasks/task_widgets.dart';
import '../notes/notes_section.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider(projectId));
    return project.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Fehler: $e'))),
      data: (p) => p == null
          ? Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                icon: Icons.folder_outlined,
                message: 'Projekt nicht gefunden.',
              ),
            )
          : _ProjectDetail(overview: p),
    );
  }
}

Future<String?> _askText(
  BuildContext context,
  String title,
  String label,
) async => (await showTextPrompt(context, title: title, label: label))?.text;

class _ProjectDetail extends ConsumerWidget {
  const _ProjectDetail({required this.overview});

  final ProjectOverview overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = overview.project;
    final repo = ref.read(projectsRepositoryProvider);
    final milestones = ref.watch(milestonesProvider(p.id));
    final criteria = ref.watch(criteriaProvider(p.id));
    final tasks = ref.watch(
      taskListProvider((
        filter: TaskFilter.open,
        customerId: null,
        projectId: p.id,
      )),
    );
    final color = ColorPalette.resolve(overview.color);
    final textTheme = Theme.of(context).textTheme;
    final period = formatDateRange(p.start, p.due);

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          IconButton(
            tooltip: 'Bearbeiten',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('${AppRoutes.projects}/${p.id}/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ProjectProgressRing(overview, size: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: overview.customer == null
                            ? null
                            : () => context.go(
                                '${AppRoutes.customers}/${overview.customer!.id}',
                              ),
                        child: Text(
                          overview.customer?.name ?? 'Internes Projekt',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Status: ${p.status.label}'),
                      if (period != null) Text('Zeitraum: $period'),
                      if (p.budgetAe != null)
                        Text(
                          'Budget: ${p.budgetAe} AE · '
                          'Warnung ab ${p.warnPercent} %',
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SectionHeader(
            'Meilensteine',
            trailing: IconButton(
              tooltip: 'Meilenstein hinzufügen',
              icon: const Icon(Icons.add),
              onPressed: () async {
                final title = await _askText(
                  context,
                  'Neuer Meilenstein',
                  'Titel',
                );
                if (title != null) await repo.addMilestone(p.id, title);
              },
            ),
          ),
          milestones.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Fehler: $e'),
            data: (list) => list.isEmpty
                ? const ListTile(title: Text('Noch keine Meilensteine'))
                : ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    onReorderItem: (oldIndex, newIndex) {
                      final ids = list.map((m) => m.id).toList();
                      ids.insert(newIndex, ids.removeAt(oldIndex));
                      repo.reorderMilestones(p.id, ids);
                    },
                    children: [
                      for (final (i, m) in list.indexed)
                        _MilestoneTile(
                          key: ValueKey(m.id),
                          milestone: m,
                          index: i,
                        ),
                    ],
                  ),
          ),
          SectionHeader(
            'Offene Aufgaben',
            trailing: IconButton(
              tooltip: 'Aufgabe erfassen',
              icon: const Icon(Icons.add_task),
              onPressed: () => showQuickCapture(
                context,
                customerId: p.customerId,
                projectId: p.id,
              ),
            ),
          ),
          tasks.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Fehler: $e'),
            data: (list) => list.isEmpty
                ? const ListTile(title: Text('Keine offenen Aufgaben'))
                : Column(
                    children: [
                      for (final t in list)
                        TaskListItem(
                          t,
                          key: ValueKey(t.task.id),
                          showCustomer: false,
                        ),
                    ],
                  ),
          ),
          SectionHeader(
            'Abschlusskriterien',
            trailing: IconButton(
              tooltip: 'Kriterium hinzufügen',
              icon: const Icon(Icons.add),
              onPressed: () async {
                final label = await _askText(
                  context,
                  'Neues Abschlusskriterium',
                  'Kriterium',
                );
                if (label != null) await repo.addCriterion(p.id, label);
              },
            ),
          ),
          criteria.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Fehler: $e'),
            data: (list) => list.isEmpty
                ? const ListTile(
                    title: Text('Noch keine Abschlusskriterien'),
                    subtitle: Text(
                      'Sind alle Kriterien erfüllt, gilt das Projekt als '
                      'erfüllt.',
                    ),
                  )
                : Column(
                    children: [
                      for (final c in list)
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: c.done,
                          title: Text(c.label),
                          onChanged: (v) =>
                              repo.setCriterionDone(c, v ?? false),
                          secondary: IconButton(
                            tooltip: 'Kriterium löschen',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => repo.deleteCriterion(c),
                          ),
                        ),
                    ],
                  ),
          ),
          NotesSection(type: NoteParentType.project, parentId: p.id),
        ],
      ),
    );
  }
}

class _MilestoneTile extends ConsumerWidget {
  const _MilestoneTile({
    super.key,
    required this.milestone,
    required this.index,
  });

  final Milestone milestone;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(projectsRepositoryProvider);
    final done = milestone.status == MilestoneStatus.done;
    return ListTile(
      leading: Checkbox(
        value: done,
        onChanged: (v) => repo.setMilestoneDone(milestone, v ?? false),
      ),
      title: Text(
        milestone.title,
        style: done
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      onTap: () => repo.setMilestoneDone(milestone, !done),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Meilenstein löschen',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => repo.deleteMilestone(milestone),
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
