import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/router.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/empty_state.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/task_actions.dart';
import '../tasks/task_widgets.dart';
import '../time/data/time_repository.dart';

DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

/// Monday of the week containing [day].
DateTime weekStart(DateTime day) =>
    _day(day).subtract(Duration(days: day.weekday - DateTime.monday));

final inboxTasksProvider = StreamProvider.autoDispose<List<TaskView>>(
  (ref) => ref.watch(tasksRepositoryProvider).watchInbox(),
);

final overdueTasksProvider = StreamProvider.autoDispose
    .family<List<TaskView>, DateTime>(
      (ref, today) => ref.watch(tasksRepositoryProvider).watchOverdue(today),
    );

final followUpsDueProvider = StreamProvider.autoDispose
    .family<List<TaskView>, DateTime>(
      (ref, today) =>
          ref.watch(tasksRepositoryProvider).watchFollowUpsDue(today),
    );

final plannedOnProvider = StreamProvider.autoDispose
    .family<List<TaskView>, DateTime>(
      (ref, day) => ref.watch(tasksRepositoryProvider).watchPlannedOn(day),
    );

final doneOnProvider = StreamProvider.autoDispose
    .family<List<TaskView>, DateTime>(
      (ref, day) => ref.watch(tasksRepositoryProvider).watchDoneOn(day),
    );

final taggedTasksProvider = StreamProvider.autoDispose
    .family<List<TaskView>, String>(
      (ref, tag) => ref.watch(tasksRepositoryProvider).watchTagged(tag),
    );

/// Entries of the week of [monday] that ran over midnight.
final overnightEntriesProvider = StreamProvider.autoDispose
    .family<List<EntryView>, DateTime>(
      (ref, monday) => ref
          .watch(timeRepositoryProvider)
          .watchOvernight(monday, monday.add(const Duration(days: 7))),
    );

/// Chips on Mein Tag that open the routines.
class RoutineChips extends StatelessWidget {
  const RoutineChips({super.key, required this.today});

  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final friday = today.weekday == DateTime.friday;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          ActionChip(
            avatar: const Icon(Icons.wb_sunny_outlined, size: 18),
            label: const Text('Morgenplanung'),
            onPressed: () => context.push(AppRoutes.morning),
          ),
          ActionChip(
            avatar: const Icon(Icons.nightlight_outlined, size: 18),
            label: const Text('Tagesabschluss'),
            onPressed: () => context.push(AppRoutes.dayClose),
          ),
          ActionChip(
            avatar: Icon(
              Icons.event_available_outlined,
              size: 18,
              color: friday ? Theme.of(context).colorScheme.primary : null,
            ),
            label: const Text('Wochenabschluss'),
            onPressed: () => context.push(AppRoutes.weekClose),
          ),
        ],
      ),
    );
  }
}

/// A titled block with a count; shows [empty] when there is nothing.
class RoutineSection extends StatelessWidget {
  const RoutineSection({
    super.key,
    required this.title,
    required this.count,
    required this.empty,
    required this.children,
    this.trailing,
  });

  final String title;
  final int? count;
  final String empty;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          count == null || count == 0 ? title : '$title ($count)',
          trailing: count == null || count == 0 ? null : trailing,
        ),
        if (count == null)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (count == 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: scheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    empty,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          )
        else
          ...children,
      ],
    );
  }
}

/// A task row with a colour dot, subtitle and actions.
class RoutineTaskRow extends StatelessWidget {
  const RoutineTaskRow({
    super.key,
    required this.view,
    this.subtitle,
    this.actions = const [],
    this.leading,
  });

  final TaskView view;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final t = view.task;
    final color = ColorPalette.resolve(view.color);
    final sub = subtitle ?? taskSubtitle(view);
    return InkWell(
      onTap: () => context.push(taskRoute(t.id)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
        child: Row(
          children: [
            leading ??
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.title, style: Theme.of(context).textTheme.bodyLarge),
                  if (sub.isNotEmpty)
                    Text(
                      sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}

/// Compact text button for row actions.
class RowAction extends StatelessWidget {
  const RowAction(this.label, this.onPressed, {super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    style: TextButton.styleFrom(
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      minimumSize: const Size(44, 44),
    ),
    onPressed: onPressed,
    child: Text(label),
  );
}

/// Snackbar helper that replaces the current one.
void routineSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

/// Reads tasks repository from a widget.
TasksRepository tasksRepo(WidgetRef ref) => ref.read(tasksRepositoryProvider);
