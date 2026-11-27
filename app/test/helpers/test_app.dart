import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/app.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/database_provider.dart';
import 'package:quest_log/features/notes/media/media_capture.dart';
import 'package:quest_log/features/notes/media/media_store.dart';
import 'package:quest_log/features/reminders/notification_service.dart';
import 'package:quest_log/features/reminders/reminder_scheduler.dart';
import 'package:quest_log/features/time/data/time_repository.dart';

import 'fake_media.dart';
import 'fake_notifications.dart';

/// Pumps the full app on [db] with a phone-sized viewport.
Future<void> pumpTestApp(
  WidgetTester tester,
  AppDatabase db, {
  DateTime? now,
  Stream<DateTime>? clock,
  FakeNotificationService? notifications,
  MediaStore? media,
  MediaCapture? capture,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        // A fixed clock: a periodic ticker would keep pumpAndSettle busy.
        nowProvider.overrideWith(
          (ref) => clock ?? Stream.value(now ?? DateTime.now()),
        ),
        notificationServiceProvider.overrideWithValue(
          notifications ?? FakeNotificationService(),
        ),
        if (now != null) reminderClockProvider.overrideWithValue(() => now),
        mediaStoreProvider.overrideWithValue(media ?? tempMediaStore()),
        mediaCaptureProvider.overrideWithValue(capture ?? FakeMediaCapture()),
        ...overrides,
      ],
      child: const QuestLogApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Disposes the widget tree (and its query streams) and closes [db] inside
/// the fake-async zone, so no stream cleanup is left pending.
Future<void> closeTestApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
  final closing = db.close();
  await tester.pump(const Duration(seconds: 1));
  await closing;
}

Finder navItem(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

/// Lets pending database work finish that `pumpAndSettle` alone does not
/// wait for: one-off reads from a query stream need real async time.
Future<void> settleAsync(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pumpAndSettle();
}

/// Like [settleAsync], but keeps giving real async time (file I/O, isolates)
/// until [finder] matches or [maxRounds] is reached.
Future<void> settleUntil(
  WidgetTester tester,
  Finder finder, {
  int maxRounds = 40,
}) async {
  for (var i = 0; i < maxRounds && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pump(const Duration(milliseconds: 500));
}
