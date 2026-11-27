import 'dart:async';

import 'package:quest_log/features/reminders/notification_service.dart';
import 'package:quest_log/features/reminders/reminder_planner.dart';

/// Records what the app would schedule instead of calling the platform.
class FakeNotificationService implements NotificationService {
  bool grant = true;
  int permissionRequests = 0;
  final syncs = <List<PlannedReminder>>[];
  final shown = <String>[];
  final _taps = StreamController<String>.broadcast();

  List<PlannedReminder> get pending => syncs.isEmpty ? const [] : syncs.last;

  void tap(String route) => _taps.add(route);

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<void> sync(List<PlannedReminder> plan) async => syncs.add(plan);

  @override
  Future<void> showNow(String title, String body) async => shown.add(title);

  @override
  Stream<String> get taps => _taps.stream;
}
