import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/tasks/data/tasks_repository.dart';
import 'package:quest_log/features/time/data/time_repository.dart';
import 'package:quest_log/features/time/engine/time_math.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TimeRepository repo;
  late TasksRepository tasks;
  late DateTime now;

  DateTime at(int h, [int m = 0]) => DateTime(2026, 3, 2, h, m);

  setUp(() {
    db = createTestDatabase();
    now = at(8);
    repo = TimeRepository(db, clock: () => now);
    tasks = TasksRepository(db);
  });
  tearDown(() => db.close());

  Future<String> customer(String name) async =>
      (await db
              .into(db.customers)
              .insertReturning(CustomersCompanion.insert(name: name)))
          .id;

  Future<String> task(String title, {String? customerId}) => tasks.createTask(
    TasksCompanion.insert(
      title: title,
      customerId: Value(customerId),
      status: const Value(TaskStatus.planned),
    ),
  );

  Future<List<String>> runningTitles() async =>
      (await repo.watchRunning().first).map((v) => v.title).toList();

  test(
    'start creates an entry, sets in progress and starts the clock',
    () async {
      final k = await customer('Beispiel GmbH');
      final a = await task('Drucker', customerId: k);
      await repo.start(a);

      expect(await runningTitles(), ['Drucker']);
      final running = (await repo.watchRunning().first).single;
      expect(running.entry.customerId, k);
      expect(running.entry.billable, isTrue);
      expect((await tasks.getTask(a))!.status, TaskStatus.inProgress);

      final clock = (await repo.watchClock(now).first)!;
      expect(clock.start, at(8));
      expect(clock.isEnded, isFalse);

      // Starting again does nothing.
      await repo.start(a);
      expect(await runningTitles(), hasLength(1));
    },
  );

  test('parallel timers, pause others and resume after interruption', () async {
    final a = await task('Installation');
    final b = await task('Mail');
    final c = await task('Anruf');

    await repo.start(a);
    await repo.setKind(a, TimeEntryKind.background);
    now = at(8, 10);
    await repo.start(b);
    expect(await runningTitles(), unorderedEquals(['Installation', 'Mail']));

    now = at(8, 20);
    await repo.start(c, pauseOthers: true);
    // Background timer keeps running, active one is paused.
    expect(await runningTitles(), unorderedEquals(['Installation', 'Anruf']));

    now = at(8, 30);
    final toResume = await repo.pause(c);
    expect(toResume, [b]);
    await repo.resume(toResume);
    expect(await runningTitles(), unorderedEquals(['Installation', 'Mail']));

    // Nothing to resume a second time.
    await repo.start(c);
    expect(await repo.pause(c), isEmpty);
  });

  test('setKind splits the entry at the switch', () async {
    final a = await task('Update');
    await repo.start(a);
    now = at(8, 15);
    await repo.setKind(a, TimeEntryKind.background);
    now = at(8, 45);
    await repo.pause(a);

    final entries = await repo.watchTaskEntries(a).first;
    expect(entries.map((e) => (e.entry.kind, e.entry.start, e.entry.end)), [
      (TimeEntryKind.active, at(8), at(8, 15)),
      (TimeEntryKind.background, at(8, 15), at(8, 45)),
    ]);
  });

  test('quick start creates an in-progress task with category', () async {
    final id = await repo.quickStart(QuickStartKind.phone);
    final t = (await tasks.getTask(id))!;
    expect(t.title, 'Telefon');
    expect(t.source, TaskSource.phone);
    final running = (await repo.watchRunning().first).single;
    expect(running.entry.category, 'phone');
    expect(running.entry.billable, isFalse);
  });

  test('clock pause stops timers and resume restarts them', () async {
    final a = await task('Arbeit');
    await repo.start(a);
    now = at(12);
    await repo.pauseClock();
    expect(await runningTitles(), isEmpty);
    var clock = (await repo.watchClock(now).first)!;
    expect(clock.isPaused, isTrue);

    now = at(12, 30);
    await repo.resumeClock();
    expect(await runningTitles(), ['Arbeit']);
    clock = (await repo.watchClock(now).first)!;
    expect(clock.isPaused, isFalse);
    expect(clock.pauses, [TimeSpan(at(12), at(12, 30))]);

    now = at(13);
    expect(clock.spans(now), [
      TimeSpan(at(8), at(12)),
      TimeSpan(at(12, 30), at(13)),
    ]);
  });

  test(
    'end of day stops everything; a later start reopens the clock',
    () async {
      final a = await task('Arbeit');
      await repo.start(a);
      now = at(16);
      await repo.endClock();
      expect(await runningTitles(), isEmpty);
      expect((await repo.watchClock(now).first)!.end, at(16));

      now = at(18);
      await repo.start(a);
      final clock = (await repo.watchClock(now).first)!;
      expect(clock.isEnded, isFalse);
      expect(clock.pauses, [TimeSpan(at(16), at(18))]);
    },
  );

  test('gaps and allocation for a day', () async {
    final a = await task('A');
    final b = await task('B');
    await repo.start(a);
    now = at(9);
    await repo.pause(a);
    now = at(9, 20);
    await repo.start(b);
    now = at(10);
    await repo.pause(b);

    final day = await repo.watchDay(now).first;
    final clock = (await repo.watchClock(now).first)!;
    final spans = day.map((v) => v.toSpan(now)).toList();
    expect(findGaps(clock.spans(now), spans), [TimeSpan(at(9), at(9, 20))]);

    await repo.addEntry(start: at(9), end: at(9, 20), category: 'phone');
    final day2 = await repo.watchDay(now).first;
    expect(
      findGaps(clock.spans(now), day2.map((v) => v.toSpan(now)).toList()),
      isEmpty,
    );
  });

  test('allocated task time and customer month units', () async {
    final k = await customer('Beispiel GmbH');
    final a = await task('A', customerId: k);
    final b = await task('B');
    await repo.start(a);
    await repo.start(b);
    now = at(9);
    await repo.pause(a);
    await repo.pause(b);

    // One hour shared by two active timers.
    expect(await repo.allocatedForTask(a), const Duration(minutes: 30));
    expect(await repo.customerMonthAe(k, now), 3);

    await repo.addEntry(
      start: DateTime(2026, 3, 5, 10),
      end: DateTime(2026, 3, 5, 10, 5),
      taskId: a,
    );
    // Rounded per task and day: 3 + 1.
    expect(await repo.customerMonthAe(k, now), 4);
    expect(await repo.customerMonthAe(k, DateTime(2026, 4)), 0);
  });

  test('manual entry validation and delete', () async {
    expect(() => repo.addEntry(start: at(10), end: at(9)), throwsArgumentError);
    final id = await repo.addEntry(
      start: at(9),
      end: at(10),
      note: 'Besprechung',
    );
    expect((await repo.watchDay(now).first).single.title, 'Besprechung');
    await repo.deleteEntry(id);
    expect(await repo.watchDay(now).first, isEmpty);
  });
}
