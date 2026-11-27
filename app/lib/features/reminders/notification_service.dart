import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'reminder_planner.dart';

/// Schedules local notifications. Swapped for a fake in tests.
abstract class NotificationService {
  /// Asks the OS for permission to show notifications.
  Future<bool> requestPermission();

  /// Replaces all pending reminders with [plan].
  Future<void> sync(List<PlannedReminder> plan);

  /// Shows a notification right away (used for the test button).
  Future<void> showNow(String title, String body);

  /// Routes of notifications the user tapped.
  Stream<String> get taps;
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = LocalNotificationService();
  ref.onDispose(service.dispose);
  return service;
});

/// [NotificationService] backed by flutter_local_notifications.
class LocalNotificationService implements NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _taps = StreamController<String>.broadcast();
  Future<bool>? _ready;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Erinnerungen',
      channelDescription: 'Termine, Nachfassen, Timer und Tagesabschluss',
      importance: Importance.high,
      priority: Priority.high,
    ),
    macOS: DarwinNotificationDetails(),
  );

  @override
  Stream<String> get taps => _taps.stream;

  void dispose() => _taps.close();

  Future<bool> _init() => _ready ??= _doInit();

  Future<bool> _doInit() async {
    try {
      // Reminders are scheduled at absolute instants, so UTC suffices and
      // no time zone lookup is needed.
      tz_data.initializeTimeZones();
      final ok = await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          macOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
          ),
          linux: LinuxInitializationSettings(defaultActionName: 'Öffnen'),
          windows: WindowsInitializationSettings(
            appName: 'Quest-Log',
            appUserModelId: 'dev.fenron.QuestLog',
            guid: '7c3e1f4a-2b6d-4e8f-9a1c-5d2b7e9f0a3c',
          ),
        ),
        onDidReceiveNotificationResponse: (r) {
          final route = r.payload;
          if (route != null && route.isNotEmpty) _taps.add(route);
        },
      );
      final launch = await _plugin.getNotificationAppLaunchDetails();
      final route = launch?.notificationResponse?.payload;
      if ((launch?.didNotificationLaunchApp ?? false) &&
          route != null &&
          route.isNotEmpty) {
        // Deliver after listeners are attached.
        scheduleMicrotask(() => _taps.add(route));
      }
      return ok ?? false;
    } catch (e) {
      debugPrint('Notifications unavailable: ${e.runtimeType}');
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (!await _init()) return false;
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return await _plugin
                  .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin
                  >()
                  ?.requestNotificationsPermission() ??
              false;
        case TargetPlatform.macOS:
          return await _plugin
                  .resolvePlatformSpecificImplementation<
                    MacOSFlutterLocalNotificationsPlugin
                  >()
                  ?.requestPermissions(alert: true, sound: true) ??
              false;
        default:
          return true;
      }
    } catch (e) {
      debugPrint('Notification permission failed: ${e.runtimeType}');
      return false;
    }
  }

  @override
  Future<void> sync(List<PlannedReminder> plan) async {
    if (!await _init()) return;
    try {
      await _plugin.cancelAllPendingNotifications();
    } catch (e) {
      debugPrint('Cancelling reminders failed: ${e.runtimeType}');
    }
    for (final r in plan) {
      try {
        await _plugin.zonedSchedule(
          id: r.id,
          title: r.title,
          body: r.body,
          scheduledDate: tz.TZDateTime.from(r.at, tz.UTC),
          notificationDetails: _details,
          // Inexact: needs no exact-alarm permission; may be a few
          // minutes late on Android.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: r.route,
        );
      } catch (e) {
        // Scheduling is unsupported on some desktop platforms.
        debugPrint('Scheduling reminder failed: ${e.runtimeType}');
        return;
      }
    }
  }

  @override
  Future<void> showNow(String title, String body) async {
    if (!await _init()) return;
    try {
      await _plugin.show(
        id: 1,
        title: title,
        body: body,
        notificationDetails: _details,
      );
    } catch (e) {
      debugPrint('Showing notification failed: ${e.runtimeType}');
    }
  }
}
