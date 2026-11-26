import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/time_settings.dart';
import '../engine/time_math.dart';

/// Quick-start categories: one tap starts a timer.
enum QuickStartKind {
  remote('Fernwartung', null),
  phone('Telefon', TaskSource.phone),
  onSite('Vor Ort', null);

  const QuickStartKind(this.label, this.source);
  final String label;
  final TaskSource? source;

  static String? labelFor(String? name) {
    if (name == 'internal') return 'Intern';
    for (final k in values) {
      if (k.name == name) return k.label;
    }
    return name;
  }
}

/// A time entry with the records it refers to.
class EntryView {
  const EntryView({
    required this.entry,
    this.task,
    this.customer,
    this.project,
  });

  final TimeEntry entry;
  final Task? task;
  final Customer? customer;
  final Project? project;

  bool get isRunning => entry.end == null;

  int? get color => project?.color ?? customer?.color;

  String get title =>
      task?.title ??
      QuickStartKind.labelFor(entry.category) ??
      entry.note ??
      'Ohne Zuordnung';

  EntrySpan toSpan(DateTime now) => EntrySpan(
    id: entry.id,
    start: entry.start,
    end: entry.end ?? now,
    background: entry.kind == TimeEntryKind.background,
    taskId: entry.taskId,
    customerId: entry.customerId,
    billable: entry.billable,
  );
}

/// Work clock of one day.
class WorkClockView {
  const WorkClockView({
    required this.start,
    required this.end,
    required this.pauses,
    required this.openPauseStart,
  });

  final DateTime start;
  final DateTime? end;

  /// Completed pauses.
  final List<TimeSpan> pauses;

  /// Start of a pause that is still running, if any.
  final DateTime? openPauseStart;

  bool get isPaused => openPauseStart != null;
  bool get isEnded => end != null;

  List<TimeSpan> spans(DateTime now) => clockSpans(
    start: start,
    end: end,
    pauses: [
      ...pauses,
      if (openPauseStart != null) TimeSpan(openPauseStart!, now),
    ],
    now: now,
  );
}

DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

String _encodePauses(List<(DateTime, DateTime?)> pauses) => jsonEncode([
  for (final (s, e) in pauses)
    [s.millisecondsSinceEpoch, e?.millisecondsSinceEpoch],
]);

List<(DateTime, DateTime?)> _decodePauses(String? raw) {
  if (raw == null || raw.isEmpty) return [];
  try {
    final list = jsonDecode(raw) as List;
    return [
      for (final p in list.cast<List>())
        (
          DateTime.fromMillisecondsSinceEpoch(p[0] as int),
          p[1] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(p[1] as int),
        ),
    ];
  } on Object {
    return [];
  }
}

WorkClockView _toClockView(WorkClock c) {
  final pauses = _decodePauses(c.pauses);
  return WorkClockView(
    start: c.start,
    end: c.end,
    pauses: [
      for (final (s, e) in pauses)
        if (e != null && e.isAfter(s)) TimeSpan(s, e),
    ],
    openPauseStart: pauses
        .where((p) => p.$2 == null)
        .map((p) => p.$1)
        .firstOrNull,
  );
}

class TimeRepository {
  TimeRepository(this._db, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  static const _clockResumeKey = 'resume:clock';
  static String _resumeKey(String taskId) => 'resume:$taskId';

  // Queries

  JoinedSelectStatement<HasResultSet, dynamic> _entryQuery() {
    final e = _db.timeEntries;
    return _db.select(e).join([
        leftOuterJoin(_db.tasks, _db.tasks.id.equalsExp(e.taskId)),
        leftOuterJoin(_db.customers, _db.customers.id.equalsExp(e.customerId)),
        leftOuterJoin(_db.projects, _db.projects.id.equalsExp(e.projectId)),
      ])
      ..where(e.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: e.start)]);
  }

  EntryView _toEntryView(TypedResult row) => EntryView(
    entry: row.readTable(_db.timeEntries),
    task: row.readTableOrNull(_db.tasks),
    customer: row.readTableOrNull(_db.customers),
    project: row.readTableOrNull(_db.projects),
  );

  Stream<List<EntryView>> watchRunning() {
    final q = _entryQuery()..where(_db.timeEntries.end.isNull());
    return q.watch().map((rows) => rows.map(_toEntryView).toList());
  }

  /// Entries overlapping [from, to).
  Expression<bool> _overlaps(DateTime from, DateTime to) {
    final e = _db.timeEntries;
    return e.start.isSmallerThanValue(to) &
        (e.end.isNull() | e.end.isBiggerThanValue(from));
  }

  Stream<List<EntryView>> watchDay(DateTime day) {
    final from = dayOf(day);
    final to = from.add(const Duration(days: 1));
    final q = _entryQuery()..where(_overlaps(from, to));
    return q.watch().map((rows) => rows.map(_toEntryView).toList());
  }

  Future<List<EntryView>> entriesBetween(DateTime from, DateTime to) async {
    final q = _entryQuery()..where(_overlaps(from, to));
    return (await q.get()).map(_toEntryView).toList();
  }

  Stream<List<EntryView>> watchTaskEntries(String taskId) {
    final q = _entryQuery()..where(_db.timeEntries.taskId.equals(taskId));
    return q.watch().map((rows) => rows.map(_toEntryView).toList());
  }

  Future<TimeEntry?> _runningEntry(String taskId) =>
      (_db.select(_db.timeEntries)..where(
            (e) =>
                e.taskId.equals(taskId) & e.end.isNull() & e.deletedAt.isNull(),
          ))
          .getSingleOrNull();

  Future<List<TimeEntry>> _allRunning() => (_db.select(
    _db.timeEntries,
  )..where((e) => e.end.isNull() & e.deletedAt.isNull())).get();

  Future<void> _endEntry(String id, DateTime at) =>
      (_db.update(_db.timeEntries)..where((e) => e.id.equals(id))).write(
        TimeEntriesCompanion(end: Value(at), updatedAt: Value(at)),
      );

  // Work clock

  Stream<WorkClockView?> watchClock(DateTime day) =>
      (_db.select(_db.workClocks)
            ..where((c) => c.day.equals(dayOf(day)) & c.deletedAt.isNull()))
          .watchSingleOrNull()
          .map((c) => c == null ? null : _toClockView(c));

  Future<WorkClock?> _clockRow(DateTime day) =>
      (_db.select(_db.workClocks)
            ..where((c) => c.day.equals(dayOf(day)) & c.deletedAt.isNull()))
          .getSingleOrNull();

  Future<void> _writePauses(String clockId, List<(DateTime, DateTime?)> p) =>
      (_db.update(_db.workClocks)..where((c) => c.id.equals(clockId))).write(
        WorkClocksCompanion(
          pauses: Value(_encodePauses(p)),
          updatedAt: Value(_now()),
        ),
      );

  /// Starts today's clock if needed. Reopens an ended clock (the time since
  /// it ended counts as a pause) and closes an open pause.
  Future<void> ensureClock(DateTime now) async {
    final row = await _clockRow(now);
    if (row == null) {
      await _db
          .into(_db.workClocks)
          .insert(WorkClocksCompanion.insert(day: dayOf(now), start: now));
      return;
    }
    final pauses = _decodePauses(row.pauses);
    var changed = false;
    if (row.end != null) {
      pauses.add((row.end!, now));
      changed = true;
      await (_db.update(_db.workClocks)..where((c) => c.id.equals(row.id)))
          .write(const WorkClocksCompanion(end: Value(null)));
    }
    for (var i = 0; i < pauses.length; i++) {
      if (pauses[i].$2 == null) {
        pauses[i] = (pauses[i].$1, now);
        changed = true;
      }
    }
    if (changed) await _writePauses(row.id, pauses);
  }

  /// Starts a break: pauses the clock and all running timers, which are
  /// resumed with [resumeClock].
  Future<void> pauseClock() => _db.transaction(() async {
    final now = _now();
    await ensureClock(now);
    final row = (await _clockRow(now))!;
    final running = await _allRunning();
    for (final e in running) {
      await _endEntry(e.id, now);
    }
    await _db.writeSetting(
      _clockResumeKey,
      jsonEncode([
        for (final e in running)
          if (e.taskId != null) e.taskId,
      ]),
    );
    final pauses = _decodePauses(row.pauses)..add((now, null));
    await _writePauses(row.id, pauses);
  });

  Future<void> resumeClock() => _db.transaction(() async {
    final now = _now();
    await ensureClock(now);
    final raw = await _db.readSetting(_clockResumeKey);
    await _db.writeSetting(_clockResumeKey, '[]');
    final ids = raw == null
        ? <String>[]
        : (jsonDecode(raw) as List).cast<String>();
    for (final id in ids) {
      await _startInternal(id, now: now);
    }
  });

  /// Ends the working day: stops all timers and the clock.
  Future<void> endClock() => _db.transaction(() async {
    final now = _now();
    for (final e in await _allRunning()) {
      await _endEntry(e.id, now);
    }
    final row = await _clockRow(now);
    if (row == null) return;
    final pauses = [
      for (final (s, e) in _decodePauses(row.pauses)) (s, e ?? now),
    ];
    await (_db.update(_db.workClocks)..where((c) => c.id.equals(row.id))).write(
      WorkClocksCompanion(
        end: Value(now),
        pauses: Value(_encodePauses(pauses)),
        updatedAt: Value(now),
      ),
    );
  });

  /// Records a past break on the clock of [span]'s day (used when a gap
  /// is assigned as a break).
  Future<void> addClockPause(TimeSpan span) async {
    final row = await _clockRow(span.start);
    if (row == null) return;
    final pauses = _decodePauses(row.pauses)..add((span.start, span.end));
    pauses.sort((a, b) => a.$1.compareTo(b.$1));
    await _writePauses(row.id, pauses);
  }

  /// Starts today's work clock without starting a timer.
  Future<void> startDay() => ensureClock(_now());

  // Timers

  Future<void> _startInternal(
    String taskId, {
    required DateTime now,
    TimeEntryKind kind = TimeEntryKind.active,
    String? category,
  }) async {
    if (await _runningEntry(taskId) != null) return;
    final task = await (_db.select(
      _db.tasks,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (task == null) return;
    await _db
        .into(_db.timeEntries)
        .insert(
          TimeEntriesCompanion.insert(
            start: now,
            kind: Value(kind),
            taskId: Value(taskId),
            customerId: Value(task.customerId),
            projectId: Value(task.projectId),
            category: Value(category),
            billable: Value(task.customerId != null),
          ),
        );
    if (task.status != TaskStatus.inProgress) {
      await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
        TasksCompanion(
          status: const Value(TaskStatus.inProgress),
          waitingFor: const Value(null),
          waitingSince: const Value(null),
          followUpDate: const Value(null),
          updatedAt: Value(now),
        ),
      );
    }
  }

  /// Starts a timer for [taskId]. With [pauseOthers], running active timers
  /// are paused and remembered so they can be resumed when this one stops.
  Future<void> start(
    String taskId, {
    bool pauseOthers = false,
    TimeEntryKind kind = TimeEntryKind.active,
    String? category,
  }) => _db.transaction(() async {
    final now = _now();
    await ensureClock(now);
    if (pauseOthers) {
      final paused = <String>[];
      for (final e in await _allRunning()) {
        if (e.taskId == taskId || e.kind == TimeEntryKind.background) continue;
        await _endEntry(e.id, now);
        if (e.taskId != null) paused.add(e.taskId!);
      }
      if (paused.isNotEmpty) {
        await _db.writeSetting(_resumeKey(taskId), jsonEncode(paused));
      }
    }
    await _startInternal(taskId, now: now, kind: kind, category: category);
  });

  /// Pauses the timer of [taskId]. Returns the tasks that were paused when
  /// it started and are not running now, so they can be offered for resume.
  Future<List<String>> pause(String taskId) => _db.transaction(() async {
    final now = _now();
    final running = await _runningEntry(taskId);
    if (running != null) await _endEntry(running.id, now);
    final raw = await _db.readSetting(_resumeKey(taskId));
    if (raw == null) return const <String>[];
    await _db.writeSetting(_resumeKey(taskId), '[]');
    final ids = (jsonDecode(raw) as List).cast<String>();
    final stillRunning = {
      for (final e in await _allRunning())
        if (e.taskId != null) e.taskId!,
    };
    return ids.where((id) => !stillRunning.contains(id)).toList();
  });

  Future<void> resume(List<String> taskIds) => _db.transaction(() async {
    final now = _now();
    await ensureClock(now);
    for (final id in taskIds) {
      await _startInternal(id, now: now);
    }
  });

  Future<bool> isRunning(String taskId) async =>
      await _runningEntry(taskId) != null;

  /// Switches a running timer between active and background. The running
  /// entry is closed and a new one starts, so history stays exact.
  Future<void> setKind(String taskId, TimeEntryKind kind) =>
      _db.transaction(() async {
        final running = await _runningEntry(taskId);
        if (running == null || running.kind == kind) return;
        final now = _now();
        await _endEntry(running.id, now);
        await _startInternal(
          taskId,
          now: now,
          kind: kind,
          category: running.category,
        );
      });

  /// One tap: creates a task for the category and starts its timer.
  Future<String> quickStart(
    QuickStartKind kind, {
    bool pauseOthers = true,
    String? customerId,
  }) async {
    final now = _now();
    final taskId =
        (await _db
                .into(_db.tasks)
                .insertReturning(
                  TasksCompanion.insert(
                    title: kind.label,
                    status: const Value(TaskStatus.inProgress),
                    plannedDay: Value(dayOf(now)),
                    source: Value(kind.source),
                    customerId: Value(customerId),
                  ),
                ))
            .id;
    await start(taskId, pauseOthers: pauseOthers, category: kind.name);
    return taskId;
  }

  /// Stops the timer of a task (e.g. when it is completed).
  Future<void> stop(String taskId) async {
    final running = await _runningEntry(taskId);
    if (running != null) await _endEntry(running.id, _now());
    await _db.writeSetting(_resumeKey(taskId), '[]');
  }

  // Manual entries

  Future<String> addEntry({
    required DateTime start,
    required DateTime end,
    String? taskId,
    String? customerId,
    String? projectId,
    String? category,
    String? note,
    bool? billable,
  }) async {
    if (!end.isAfter(start)) {
      throw ArgumentError('end must be after start');
    }
    String? c = customerId;
    String? p = projectId;
    if (taskId != null) {
      final task = await (_db.select(
        _db.tasks,
      )..where((t) => t.id.equals(taskId))).getSingleOrNull();
      c ??= task?.customerId;
      p ??= task?.projectId;
    }
    final row = await _db
        .into(_db.timeEntries)
        .insertReturning(
          TimeEntriesCompanion.insert(
            start: start,
            end: Value(end),
            taskId: Value(taskId),
            customerId: Value(c),
            projectId: Value(p),
            category: Value(category),
            note: Value(note),
            billable: Value(billable ?? c != null),
          ),
        );
    return row.id;
  }

  Future<void> deleteEntry(String id) => _db.softDelete(_db.timeEntries, id);

  /// Updates a time entry. A running entry keeps `end` null.
  Future<void> updateEntry(
    String id, {
    required DateTime start,
    required DateTime? end,
    required String? taskId,
    required String? customerId,
    required String? projectId,
    required TimeEntryKind kind,
    required bool billable,
    required String? note,
  }) async {
    if (end != null && !end.isAfter(start)) {
      throw ArgumentError('end must be after start');
    }
    await (_db.update(_db.timeEntries)..where((e) => e.id.equals(id))).write(
      TimeEntriesCompanion(
        start: Value(start),
        end: Value(end),
        taskId: Value(taskId),
        customerId: Value(customerId),
        projectId: Value(projectId),
        kind: Value(kind),
        billable: Value(billable),
        note: Value(note),
        updatedAt: Value(_now()),
      ),
    );
  }

  /// Assigns a task (and all of its time entries) to a customer and
  /// project, e.g. when a quick-start turns out to belong to a project.
  Future<void> assignTask(
    String taskId, {
    required String? customerId,
    required String? projectId,
  }) => _db.transaction(() async {
    final now = _now();
    final task = await (_db.select(
      _db.tasks,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (task == null) return;
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        customerId: Value(customerId),
        projectId: Value(projectId),
        milestoneId: projectId == task.projectId
            ? const Value.absent()
            : const Value(null),
        updatedAt: Value(now),
      ),
    );
    final hadCustomer = task.customerId != null;
    await (_db.update(
      _db.timeEntries,
    )..where((e) => e.taskId.equals(taskId) & e.deletedAt.isNull())).write(
      TimeEntriesCompanion(
        customerId: Value(customerId),
        projectId: Value(projectId),
        // Becomes billable when a customer is assigned for the first
        // time; existing choices are kept otherwise.
        billable: !hadCustomer && customerId != null
            ? const Value(true)
            : customerId == null
            ? const Value(false)
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  });

  // Totals

  /// Allocated time per task across all days on which it has entries.
  Future<Duration> allocatedForTask(
    String taskId, {
    double backgroundWeight = 0.5,
  }) async {
    final own = await (_db.select(
      _db.timeEntries,
    )..where((e) => e.taskId.equals(taskId) & e.deletedAt.isNull())).get();
    if (own.isEmpty) return Duration.zero;
    final now = _now();
    final from = own
        .map((e) => e.start)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final to = own
        .map((e) => e.end ?? now)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final all = await entriesBetween(from, to.add(const Duration(seconds: 1)));
    final spans = all.map((v) => v.toSpan(now)).toList();
    final alloc = allocate(spans, backgroundWeight: backgroundWeight);
    return sumBy(spans, alloc, (e) => e.taskId)[taskId] ?? Duration.zero;
  }

  /// Rounded work units for a customer in the month of [month], rounded
  /// per task (or category) and day.
  Future<int> customerMonthAe(
    String customerId,
    DateTime month, {
    double backgroundWeight = 0.5,
    int aeMinutes = 10,
  }) async {
    final (from, to) = _monthRange(month);
    return _customerAe(
      await entriesBetween(from, to),
      customerId,
      backgroundWeight: backgroundWeight,
      aeMinutes: aeMinutes,
    );
  }

  Stream<int> watchCustomerMonthAe(
    String customerId,
    DateTime month, {
    double backgroundWeight = 0.5,
    int aeMinutes = 10,
  }) {
    final (from, to) = _monthRange(month);
    final q = _entryQuery()..where(_overlaps(from, to));
    return q.watch().map(
      (rows) => _customerAe(
        rows.map(_toEntryView).toList(),
        customerId,
        backgroundWeight: backgroundWeight,
        aeMinutes: aeMinutes,
      ),
    );
  }

  (DateTime, DateTime) _monthRange(DateTime month) => (
    DateTime(month.year, month.month),
    DateTime(month.year, month.month + 1),
  );

  int _customerAe(
    List<EntryView> all,
    String customerId, {
    required double backgroundWeight,
    required int aeMinutes,
  }) {
    final now = _now();
    final spans = all.map((v) => v.toSpan(now)).toList();
    final alloc = allocate(spans, backgroundWeight: backgroundWeight);
    final buckets = <String, Duration>{};
    for (final v in all) {
      if (v.entry.customerId != customerId) continue;
      final key =
          '${v.entry.taskId ?? v.entry.category}|${dayOf(v.entry.start)}';
      buckets[key] =
          (buckets[key] ?? Duration.zero) +
          (alloc[v.entry.id] ?? Duration.zero);
    }
    return roundedAeTotal(buckets.values, aeMinutes: aeMinutes);
  }
}

final timeRepositoryProvider = Provider<TimeRepository>(
  (ref) => TimeRepository(ref.watch(databaseProvider)),
);

/// Ticks every second for live timer displays. Overridden in tests.
final nowProvider = StreamProvider<DateTime>(
  (ref) => Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
);

final runningTimersProvider = StreamProvider.autoDispose<List<EntryView>>(
  (ref) => ref.watch(timeRepositoryProvider).watchRunning(),
);

final dayEntriesProvider = StreamProvider.autoDispose
    .family<List<EntryView>, DateTime>(
      (ref, day) => ref.watch(timeRepositoryProvider).watchDay(day),
    );

final dayClockProvider = StreamProvider.autoDispose
    .family<WorkClockView?, DateTime>(
      (ref, day) => ref.watch(timeRepositoryProvider).watchClock(day),
    );

final taskEntriesProvider = StreamProvider.autoDispose
    .family<List<EntryView>, String>(
      (ref, taskId) =>
          ref.watch(timeRepositoryProvider).watchTaskEntries(taskId),
    );

/// Work units used by a customer in the current month.
final customerMonthAeProvider = StreamProvider.autoDispose.family<int, String>((
  ref,
  customerId,
) {
  final settings = ref.watch(currentTimeSettingsProvider);
  return ref
      .watch(timeRepositoryProvider)
      .watchCustomerMonthAe(
        customerId,
        DateTime.now(),
        backgroundWeight: settings.backgroundWeight,
        aeMinutes: settings.aeMinutes,
      );
});
