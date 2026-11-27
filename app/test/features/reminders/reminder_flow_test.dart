import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';

import '../../helpers/fake_notifications.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeNotificationService notifications;
  final now = DateTime(2026, 3, 2, 9);

  setUp(() {
    db = createTestDatabase();
    notifications = FakeNotificationService();
  });

  Future<String> seed() async =>
      (await db
              .into(db.tasks)
              .insertReturning(
                TasksCompanion.insert(
                  title: 'Wartung',
                  status: const Value(TaskStatus.planned),
                  plannedDay: Value(DateTime(2026, 3, 2, 14)),
                ),
              ))
          .id;

  Finder reminderSwitch() =>
      find.widgetWithText(SwitchListTile, 'Erinnerungen');

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Einstellungen'));
    await settleAsync(tester);
    await tester.scrollUntilVisible(
      reminderSwitch(),
      200,
      scrollable: find.descendant(
        of: find.byType(ListView).last,
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('enabling asks first, then schedules reminders', (tester) async {
    await tester.runAsync(seed);
    await pumpTestApp(tester, db, now: now, notifications: notifications);
    // Nothing touches the platform while reminders are off.
    expect(notifications.syncs, isEmpty);

    await openSettings(tester);
    await tester.tap(reminderSwitch());
    await tester.pumpAndSettle();
    expect(find.text('Erinnerungen erlauben?'), findsOneWidget);
    expect(notifications.permissionRequests, 0);

    await tester.tap(find.text('Weiter'));
    await settleAsync(tester);
    expect(notifications.permissionRequests, 1);
    expect(find.text('Timer-Schutz'), findsOneWidget);

    final keys = notifications.pending.map((r) => r.key);
    expect(keys, contains(startsWith('appointment:')));
    expect(keys, contains(startsWith('dayclose:')));

    // Switching off cancels everything.
    await tester.tap(reminderSwitch());
    await settleAsync(tester);
    expect(notifications.pending, isEmpty);

    await closeTestApp(tester, db);
  });

  testWidgets('denied permission keeps reminders off', (tester) async {
    notifications.grant = false;
    await pumpTestApp(tester, db, now: now, notifications: notifications);
    await openSettings(tester);
    await tester.tap(reminderSwitch());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Weiter'));
    await settleAsync(tester);

    expect(find.textContaining('Keine Erlaubnis'), findsOneWidget);
    expect(find.text('Timer-Schutz'), findsNothing);
    expect(notifications.syncs, isEmpty);

    await closeTestApp(tester, db);
  });

  testWidgets('tapping a notification opens its target', (tester) async {
    final id = (await tester.runAsync(seed))!;
    await pumpTestApp(tester, db, now: now, notifications: notifications);
    notifications.tap('/task/$id');
    await settleAsync(tester);
    expect(find.widgetWithText(AppBar, 'Aufgabe'), findsOneWidget);
    expect(find.text('Wartung'), findsWidgets);

    await closeTestApp(tester, db);
  });
}
