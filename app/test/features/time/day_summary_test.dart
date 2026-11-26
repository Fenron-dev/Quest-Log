import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/settings/time_settings.dart';
import 'package:quest_log/features/time/data/time_repository.dart';
import 'package:quest_log/features/time/day_summary.dart';
import 'package:quest_log/features/time/engine/time_math.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TimeRepository repo;
  DateTime at(int h, [int m = 0]) => DateTime(2026, 3, 2, h, m);
  var now = at(8);

  setUp(() {
    db = createTestDatabase();
    now = at(8);
    repo = TimeRepository(db, clock: () => now);
  });
  tearDown(() => db.close());

  Future<String> task(String title, {String? customerId}) async =>
      (await db
              .into(db.tasks)
              .insertReturning(
                TasksCompanion.insert(
                  title: title,
                  customerId: Value(customerId),
                ),
              ))
          .id;

  Future<DaySummary> summary({
    TimeSettings settings = const TimeSettings(),
  }) async => DaySummary.compute(
    day: now,
    entries: await repo.watchDay(now).first,
    clock: await repo.watchClock(now).first,
    now: now,
    settings: settings,
  );

  test('totals, units per task, billable share, gaps and running', () async {
    final k =
        (await db
                .into(db.customers)
                .insertReturning(
                  CustomersCompanion.insert(name: 'Beispiel GmbH'),
                ))
            .id;
    final a = await task('A', customerId: k);
    final b = await task('B');

    await repo.start(a); // 08:00
    now = at(8, 25);
    await repo.pause(a);
    now = at(8, 40);
    await repo.start(b); // gap 08:25–08:40
    now = at(9);

    final s = await summary();
    expect(s.runningCount, 1);
    expect(s.recorded, const Duration(minutes: 45));
    expect(s.billable, const Duration(minutes: 25));
    expect(s.taskTotal(a), const Duration(minutes: 25));
    // 25 min → 3 AE, 20 min → 2 AE.
    expect(s.ae, 5);
    expect(s.gaps, [TimeSpan(at(8, 25), at(8, 40))]);

    final fifteen = await summary(settings: const TimeSettings(aeMinutes: 15));
    expect(fifteen.ae, 2 + 2);
  });

  test('entries crossing midnight are clamped to the day', () async {
    final a = await task('Nachtschicht');
    await repo.addEntry(start: DateTime(2026, 3, 1, 23), end: at(1), taskId: a);
    final s = await summary();
    expect(s.taskTotal(a), const Duration(hours: 1));
  });
}
