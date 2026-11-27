import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/routing/router.dart';
import '../tasks/data/tasks_repository.dart';
import '../time/data/time_repository.dart';
import 'notification_service.dart';
import 'reminder_planner.dart';
import 'reminder_settings.dart';

/// Wall clock for planning; overridable in tests.
final reminderClockProvider = Provider<DateTime Function()>(
  (_) => DateTime.now,
);

final reminderTasksProvider = StreamProvider.autoDispose<List<TaskView>>(
  (ref) => ref.watch(tasksRepositoryProvider).watchReminderTasks(),
);

/// The reminders that should be pending right now, or null while loading.
final reminderPlanProvider = Provider.autoDispose<List<PlannedReminder>?>((
  ref,
) {
  final settings = ref.watch(reminderSettingsProvider).value;
  if (settings == null) return null;
  if (!settings.enabled) return const [];
  final tasks = ref.watch(reminderTasksProvider).value;
  final running = ref.watch(runningTimersProvider).value;
  if (tasks == null || running == null) return null;
  return planReminders(
    now: ref.read(reminderClockProvider)(),
    settings: settings,
    tasks: tasks,
    running: running,
  );
});

/// Keeps scheduled notifications in line with the data and opens the
/// target of a tapped notification.
class ReminderHost extends ConsumerStatefulWidget {
  const ReminderHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReminderHost> createState() => _ReminderHostState();
}

class _ReminderHostState extends ConsumerState<ReminderHost>
    with WidgetsBindingObserver {
  static const _refresh = Duration(minutes: 30);

  List<PlannedReminder> _synced = const [];
  StreamSubscription<String>? _taps;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _taps = ref.read(notificationServiceProvider).taps.listen(_open);
    // The plan only covers a moving window; refresh it now and then.
    _timer = Timer.periodic(_refresh, (_) => _replan());
    ref.listenManual(
      reminderPlanProvider,
      (_, next) => _apply(next),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _taps?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _replan();
  }

  void _replan() => ref.invalidate(reminderPlanProvider);

  void _open(String route) {
    if (!route.startsWith('/')) return;
    ref.read(routerProvider).push(route);
  }

  void _apply(List<PlannedReminder>? plan) {
    if (plan == null || listEquals(plan, _synced)) return;
    final enabled = ref.read(reminderSettingsProvider).value?.enabled ?? false;
    // Leave the platform alone until reminders were ever switched on.
    if (!enabled && _synced.isEmpty) return;
    _synced = plan;
    unawaited(ref.read(notificationServiceProvider).sync(plan));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
