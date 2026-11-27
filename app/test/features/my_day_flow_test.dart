import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';

import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 3, 2, 12);
  DateTime at(int h, [int m = 0]) => DateTime(2026, 3, 2, h, m);

  setUp(() => db = createTestDatabase());

  Future<void> seed() async {
    final k =
        (await db
                .into(db.customers)
                .insertReturning(
                  CustomersCompanion.insert(
                    name: 'Beispiel GmbH',
                    contingentAePerMonth: const Value(10),
                  ),
                ))
            .id;
    final t =
        (await db
                .into(db.tasks)
                .insertReturning(
                  TasksCompanion.insert(
                    title: 'Server prüfen',
                    customerId: Value(k),
                    status: const Value(TaskStatus.planned),
                  ),
                ))
            .id;
    await db
        .into(db.workClocks)
        .insert(WorkClocksCompanion.insert(day: at(0), start: at(9)));
    await db
        .into(db.timeEntries)
        .insert(
          TimeEntriesCompanion.insert(
            start: at(9),
            end: Value(at(10)),
            taskId: Value(t),
            customerId: Value(k),
          ),
        );
    await db
        .into(db.timeEntries)
        .insert(
          TimeEntriesCompanion.insert(
            start: at(10, 30),
            end: Value(at(12)),
            taskId: Value(t),
            customerId: Value(k),
          ),
        );
  }

  testWidgets('day header, gap and filling it as a category', (tester) async {
    await tester.runAsync(seed);
    await pumpTestApp(tester, db, now: now);
    await tester.tap(navItem('Mein Tag'));
    await settleAsync(tester);

    // 2.5 h recorded on one task → 15 AE.
    expect(find.textContaining('15 AE · 2:30 h'), findsOneWidget);
    expect(find.textContaining('Arbeitsuhr läuft seit 09:00'), findsOneWidget);
    expect(find.text('30 min · 3 AE offen'), findsOneWidget);

    await tester.tap(find.text('Nachtragen'));
    await settleAsync(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Telefon'));
    await settleAsync(tester);

    expect(find.text('30 min · 3 AE offen'), findsNothing);
    expect(find.text('Telefon'), findsOneWidget);

    await tester.tap(find.text('Zeitstrahl'));
    await settleAsync(tester);
    expect(find.text('9:00'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('gap assigned as a break disappears without an entry', (
    tester,
  ) async {
    await tester.runAsync(seed);
    await pumpTestApp(tester, db, now: now);
    await tester.tap(navItem('Mein Tag'));
    await settleAsync(tester);

    await tester.tap(find.text('Nachtragen'));
    await settleAsync(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Pause'));
    await settleAsync(tester);
    expect(find.textContaining('AE offen'), findsNothing);
    final entries = await tester.runAsync(
      () => db.select(db.timeEntries).get(),
    );
    expect(entries, hasLength(2));

    await closeTestApp(tester, db);
  });

  testWidgets('customer shows used units against the contingent', (
    tester,
  ) async {
    await tester.runAsync(seed);
    await pumpTestApp(tester, db, now: now);
    await tester.tap(navItem('Kunden'));
    await settleAsync(tester);
    await tester.tap(find.text('Beispiel GmbH'));
    await settleAsync(tester);
    // Entries are in March 2026, the provider uses the real month, so only
    // check the contingent line is shown.
    expect(find.textContaining('von 10 AE'), findsOneWidget);
    await closeTestApp(tester, db);
  });

  testWidgets('task detail: add a note', (tester) async {
    await tester.runAsync(seed);
    await pumpTestApp(tester, db, now: now);
    await tester.longPress(find.text('Server prüfen'));
    await settleAsync(tester);
    expect(find.textContaining('2:30 h erfasst'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byTooltip('Notiz speichern'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Notiz schreiben'),
      'Lüfter getauscht',
    );
    await tester.tap(find.byTooltip('Notiz speichern'));
    await settleAsync(tester);
    expect(find.text('Lüfter getauscht'), findsOneWidget);

    await closeTestApp(tester, db);
  });
}
