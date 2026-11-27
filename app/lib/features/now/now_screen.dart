import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/router.dart';
import '../../core/settings/time_settings.dart';
import '../../core/settings/view_settings.dart';
import '../../core/ui/empty_state.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/quick_capture_sheet.dart';
import '../tasks/task_widgets.dart';
import '../time/data/time_repository.dart';
import '../time/day_summary.dart';
import '../time/timer_widgets.dart';

class NowScreen extends ConsumerStatefulWidget {
  const NowScreen({super.key});

  @override
  ConsumerState<NowScreen> createState() => _NowScreenState();
}

class _NowScreenState extends ConsumerState<NowScreen> {
  TaskFilter _filter = TaskFilter.open;

  @override
  Widget build(BuildContext context) {
    final view = ref.watch(nowViewProvider).value ?? NowView.list;
    final tasks = ref.watch(
      taskListProvider((filter: _filter, customerId: null, projectId: null)),
    );
    final running = ref.watch(runningTimersProvider).value ?? const [];
    final summary = ref.watch(daySummaryProvider(ref.watch(todayProvider)));
    final settings = ref.watch(currentTimeSettingsProvider);
    final textTheme = Theme.of(context).textTheme;

    final header = <Widget>[
      if (settings.quickStartEnabled) const QuickStartBar(),
      if (running.isNotEmpty) ...[
        const SectionHeader('Läuft'),
        for (final r in running)
          RunningTimerCard(
            key: ValueKey(r.entry.id),
            view: r,
            summary: summary,
          ),
      ],
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text('Meine Aufgaben', style: textTheme.titleMedium),
      ),
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
    ];

    Widget body(List<TaskView> list) {
      if (list.isEmpty) {
        return CustomScrollView(
          slivers: [
            SliverList.list(children: header),
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.task_alt,
                message: _filter == TaskFilter.open
                    ? 'Nichts offen. Mit „Erfassen“ legst du in Sekunden '
                          'eine Aufgabe an.'
                    : 'Keine Aufgaben in „${_filter.label}“.',
              ),
            ),
          ],
        );
      }
      return CustomScrollView(
        slivers: [
          SliverList.list(children: header),
          if (view == NowView.tiles)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260,
                  mainAxisExtent: 150,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) =>
                    TaskTileCard(list[i], key: ValueKey(list[i].task.id)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 96),
              sliver: SliverList.builder(
                itemCount: list.length,
                itemBuilder: (_, i) =>
                    TaskListItem(list[i], key: ValueKey(list[i].task.id)),
              ),
            ),
        ],
      );
    }

    final subtitle = [
      running.isEmpty
          ? 'Kein Timer läuft'
          : running.length == 1
          ? '1 Timer läuft'
          : '${running.length} Timer laufen',
      '${summary?.ae ?? 0} AE heute',
    ].join(' · ');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jetzt'),
            Text(subtitle, style: textTheme.bodySmall),
          ],
        ),
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
          IconButton(
            tooltip: 'Einstellungen',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('${AppRoutes.now}/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickCapture(context),
        icon: const Icon(Icons.add),
        label: const Text('Erfassen'),
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: body,
      ),
    );
  }
}
