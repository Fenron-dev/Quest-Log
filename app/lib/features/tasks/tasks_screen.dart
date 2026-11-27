import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/view_settings.dart';
import '../../core/ui/empty_state.dart';
import 'data/tasks_repository.dart';
import 'quick_capture_sheet.dart';
import 'task_widgets.dart';

/// All tasks with status filters, as list or tiles. This is where tasks
/// are planned; Jetzt only shows what is running or due today.
class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskFilter _filter = TaskFilter.open;

  @override
  Widget build(BuildContext context) {
    final view = ref.watch(nowViewProvider).value ?? NowView.list;
    final tasks = ref.watch(
      taskListProvider((filter: _filter, customerId: null, projectId: null)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aufgaben'),
        actions: [
          IconButton(
            tooltip: view == NowView.list
                ? 'Als Kacheln anzeigen'
                : 'Als Liste anzeigen',
            icon: Icon(
              view == NowView.list ? Icons.grid_view : Icons.view_list,
            ),
            onPressed: () => ref
                .read(nowViewProvider.notifier)
                .set(view == NowView.list ? NowView.tiles : NowView.list),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickCapture(context),
        icon: const Icon(Icons.add),
        label: const Text('Erfassen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final f in TaskFilter.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(f.label),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: tasks.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
              data: (list) {
                if (list.isEmpty) {
                  return EmptyState(
                    icon: Icons.task_alt,
                    message: _filter == TaskFilter.open
                        ? 'Nichts offen. Mit „Erfassen“ legst du in '
                              'Sekunden eine Aufgabe an.'
                        : 'Keine Aufgaben in „${_filter.label}“.',
                  );
                }
                if (view == NowView.tiles) {
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 260,
                          mainAxisExtent: 150,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemCount: list.length,
                    itemBuilder: (_, i) =>
                        TaskTileCard(list[i], key: ValueKey(list[i].task.id)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: list.length,
                  itemBuilder: (_, i) =>
                      TaskListItem(list[i], key: ValueKey(list[i].task.id)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
