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

  Future<String> seedTask(String title) async {
    final task = await db
        .into(db.tasks)
        .insertReturning(
          TasksCompanion.insert(
            title: title,
            status: const Value(TaskStatus.planned),
            plannedDay: Value(at(0)),
          ),
        );
    return task.id;
  }

  Future<void> seedChecklist() async {
    final id = await seedTask('Drucker einrichten');
    for (final (i, label) in ['Treiber laden', 'Testseite'].indexed) {
      await db
          .into(db.checklistItems)
          .insert(
            ChecklistItemsCompanion.insert(
              taskId: id,
              label: label,
              order: Value(i),
            ),
          );
    }
  }

  testWidgets('Jetzt tile opens the checklist from its step counter', (
    tester,
  ) async {
    await tester.runAsync(seedChecklist);
    await pumpTestApp(tester, db, now: now);
    await settleAsync(tester);

    await tester.tap(find.bySemanticsLabel('Checkliste 0 von 2'));
    await settleAsync(tester);
    expect(find.text('Treiber laden'), findsOneWidget);

    await tester.tap(find.text('Treiber laden'));
    await settleAsync(tester);
    final items = await tester.runAsync(
      () => db.select(db.checklistItems).get(),
    );
    expect(items!.where((i) => i.done), hasLength(1));

    await closeTestApp(tester, db);
  });

  testWidgets('Jetzt list row unfolds the checklist', (tester) async {
    await tester.runAsync(seedChecklist);
    await pumpTestApp(tester, db, now: now);
    await settleAsync(tester);

    await tester.tap(find.byTooltip('Als Liste anzeigen'));
    await settleAsync(tester);
    expect(find.text('Testseite'), findsNothing);

    await tester.tap(find.byTooltip('Checkliste aufklappen'));
    await settleAsync(tester);
    expect(find.text('Treiber laden'), findsOneWidget);
    expect(find.text('Testseite'), findsOneWidget);

    await tester.tap(find.byTooltip('Checkliste zuklappen'));
    await settleAsync(tester);
    expect(find.text('Testseite'), findsNothing);

    await closeTestApp(tester, db);
  });

  testWidgets('short timeline entries stay readable and tappable', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final a = await seedTask('Kurz A');
      final b = await seedTask('Kurz B');
      await db
          .into(db.workClocks)
          .insert(WorkClocksCompanion.insert(day: at(0), start: at(9)));
      for (final (task, from) in [(a, 0), (b, 3)]) {
        await db
            .into(db.timeEntries)
            .insert(
              TimeEntriesCompanion.insert(
                start: at(9, from),
                end: Value(at(9, from + 3)),
                taskId: Value(task),
              ),
            );
      }
    });
    await pumpTestApp(tester, db, now: now);
    await tester.tap(find.text('Mein Tag'));
    await settleAsync(tester);
    await tester.tap(find.text('Zeitstrahl'));
    await settleAsync(tester);

    final blocks = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('timeline-entry-'),
    );
    expect(blocks, findsNWidgets(2));
    final ra = tester.getRect(blocks.at(0));
    final rb = tester.getRect(blocks.at(1));
    expect(ra.height, greaterThanOrEqualTo(28));
    expect(rb.height, greaterThanOrEqualTo(28));
    expect(ra.overlaps(rb), isFalse);

    await tester.tap(
      find.descendant(of: blocks, matching: find.text('Kurz B')),
    );
    await settleAsync(tester);
    expect(find.widgetWithText(AppBar, 'Aufgabe'), findsOneWidget);
    expect(find.text('Kurz B'), findsWidgets);

    await closeTestApp(tester, db);
  });

  testWidgets('timeline zoom stretches the hours', (tester) async {
    await tester.runAsync(() => seedTask('Platzhalter'));
    await pumpTestApp(tester, db, now: now);
    await tester.tap(find.text('Mein Tag'));
    await settleAsync(tester);
    await tester.tap(find.text('Zeitstrahl'));
    await settleAsync(tester);

    double gap() =>
        tester.getTopLeft(find.text('9:00')).dy -
        tester.getTopLeft(find.text('8:00')).dy;
    final before = gap();
    await tester.tap(find.byTooltip('Zeitstrahl vergrößern'));
    await settleAsync(tester);
    expect(gap(), closeTo(before * 2, 1));

    await closeTestApp(tester, db);
  });
}
