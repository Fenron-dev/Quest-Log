import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../templates/data/templates_repository.dart';

extension TaskStatusLabel on TaskStatus {
  String get label => switch (this) {
    TaskStatus.inbox => 'Eingang',
    TaskStatus.planned => 'Geplant',
    TaskStatus.inProgress => 'In Arbeit',
    TaskStatus.waitingFor => 'Wartet auf',
    TaskStatus.blocked => 'Blockiert',
    TaskStatus.someday => 'Irgendwann',
    TaskStatus.done => 'Erledigt',
    TaskStatus.dropped => 'Verworfen',
  };

  bool get isClosed => this == TaskStatus.done || this == TaskStatus.dropped;
}

extension TaskSourceLabel on TaskSource {
  String get label => switch (this) {
    TaskSource.mail => 'E-Mail',
    TaskSource.phone => 'Telefon',
    TaskSource.verbal => 'Mündlich',
    TaskSource.self => 'Selbst',
  };
}

enum TaskFilter {
  open('Offen'),
  inbox('Eingang'),
  waiting('Wartet'),
  someday('Irgendwann'),
  closed('Erledigt');

  const TaskFilter(this.label);
  final String label;

  List<TaskStatus> get statuses => switch (this) {
    TaskFilter.open => [
      TaskStatus.inbox,
      TaskStatus.planned,
      TaskStatus.inProgress,
      TaskStatus.waitingFor,
      TaskStatus.blocked,
    ],
    TaskFilter.inbox => [TaskStatus.inbox],
    TaskFilter.waiting => [TaskStatus.waitingFor],
    TaskFilter.someday => [TaskStatus.someday],
    TaskFilter.closed => [TaskStatus.done, TaskStatus.dropped],
  };
}

/// Thrown when a task would be saved in an inconsistent state.
class TaskValidationException implements Exception {
  const TaskValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

/// A task planned at a specific time of day is an appointment.
bool isAppointment(Task t) =>
    t.plannedDay != null &&
    (t.plannedDay!.hour != 0 || t.plannedDay!.minute != 0);

class TaskView {
  const TaskView({
    required this.task,
    required this.customer,
    required this.project,
    required this.checklistDone,
    required this.checklistTotal,
  });

  final Task task;
  final Customer? customer;
  final Project? project;
  final int checklistDone;
  final int checklistTotal;

  int? get color => project?.color ?? customer?.color;

  /// Waiting task whose follow-up date has been reached.
  bool needsFollowUp(DateTime now) =>
      task.status == TaskStatus.waitingFor &&
      task.followUpDate != null &&
      !_dayOf(task.followUpDate!).isAfter(_dayOf(now));

  List<String> get tags => decodeTags(task.tags);
}

List<String> decodeTags(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final list = jsonDecode(raw);
    return list is List ? list.whereType<String>().toList() : const [];
  } on FormatException {
    return const [];
  }
}

String? encodeTags(Iterable<String> tags) {
  final cleaned = tags.map((t) => t.trim()).where((t) => t.isNotEmpty).toSet();
  return cleaned.isEmpty ? null : jsonEncode(cleaned.toList());
}

class TasksRepository {
  TasksRepository(this._db);

  final AppDatabase _db;

  late final _checklistTotal = _checklistCount(onlyDone: false);
  late final _checklistDone = _checklistCount(onlyDone: true);

  Expression<int> _checklistCount({required bool onlyDone}) {
    final c = _db.checklistItems;
    var filter = c.taskId.equalsExp(_db.tasks.id) & c.deletedAt.isNull();
    if (onlyDone) filter &= c.done.equals(true);
    return subqueryExpression<int>(
      _db.selectOnly(c)
        ..addColumns([countAll()])
        ..where(filter),
    );
  }

  JoinedSelectStatement<HasResultSet, dynamic> _viewQuery() {
    final t = _db.tasks;
    final c = _db.customers;
    final p = _db.projects;
    return _db.select(t).join([
        leftOuterJoin(c, c.id.equalsExp(t.customerId) & c.deletedAt.isNull()),
        leftOuterJoin(p, p.id.equalsExp(t.projectId) & p.deletedAt.isNull()),
      ])
      ..addColumns([_checklistTotal, _checklistDone])
      ..where(t.deletedAt.isNull())
      ..orderBy([
        OrderingTerm.desc(t.important),
        OrderingTerm(expression: t.plannedDay, nulls: NullsOrder.last),
        OrderingTerm(expression: t.order),
        OrderingTerm(expression: t.createdAt),
      ]);
  }

  TaskView _toView(TypedResult row) => TaskView(
    task: row.readTable(_db.tasks),
    customer: row.readTableOrNull(_db.customers),
    project: row.readTableOrNull(_db.projects),
    checklistTotal: row.read(_checklistTotal) ?? 0,
    checklistDone: row.read(_checklistDone) ?? 0,
  );

  Stream<List<TaskView>> watchTasks({
    TaskFilter filter = TaskFilter.open,
    String? customerId,
    String? projectId,
  }) {
    final t = _db.tasks;
    final query = _viewQuery()
      ..where(t.status.isIn(filter.statuses.map((s) => s.name)));
    if (customerId != null) query.where(t.customerId.equals(customerId));
    if (projectId != null) query.where(t.projectId.equals(projectId));
    return query.watch().map((rows) => rows.map(_toView).toList());
  }

  /// Tasks for Jetzt: in progress (running or paused), planned for
  /// [today], or waiting with a follow-up due.
  Stream<List<TaskView>> watchFocus(DateTime today) {
    final t = _db.tasks;
    final day = _dayOf(today);
    final nextDay = day.add(const Duration(days: 1));
    final plannedToday =
        t.plannedDay.isBiggerOrEqualValue(day) &
        t.plannedDay.isSmallerThanValue(nextDay) &
        t.status.isIn([
          TaskStatus.inbox.name,
          TaskStatus.planned.name,
          TaskStatus.blocked.name,
        ]);
    final followUpDue =
        t.status.equals(TaskStatus.waitingFor.name) &
        t.followUpDate.isSmallerThanValue(nextDay);
    final query = _viewQuery()
      ..where(
        t.status.equals(TaskStatus.inProgress.name) |
            plannedToday |
            followUpDue,
      );
    return query.watch().map((rows) => rows.map(_toView).toList());
  }

  /// Open tasks planned on [day] at a specific time (appointments).
  Stream<List<TaskView>> watchAppointments(DateTime day) {
    final t = _db.tasks;
    final from = _dayOf(day);
    final to = from.add(const Duration(days: 1));
    final query = _viewQuery()
      ..where(
        t.plannedDay.isBiggerOrEqualValue(from) &
            t.plannedDay.isSmallerThanValue(to) &
            t.status.isNotIn([TaskStatus.dropped.name]),
      );
    return query.watch().map(
      (rows) =>
          rows.map(_toView).where((v) => isAppointment(v.task)).toList()
            ..sort((a, b) => a.task.plannedDay!.compareTo(b.task.plannedDay!)),
    );
  }

  /// Open tasks that can trigger a reminder: planned at a time or waiting
  /// with a follow-up date.
  Stream<List<TaskView>> watchReminderTasks() {
    final t = _db.tasks;
    final query = _viewQuery()
      ..where(
        t.status.isNotIn([TaskStatus.done.name, TaskStatus.dropped.name]) &
            (t.plannedDay.isNotNull() | t.followUpDate.isNotNull()),
      );
    return query.watch().map((rows) => rows.map(_toView).toList());
  }

  static final _openNames = [
    TaskStatus.inbox.name,
    TaskStatus.planned.name,
    TaskStatus.inProgress.name,
    TaskStatus.blocked.name,
  ];

  /// Unsorted captures.
  Stream<List<TaskView>> watchInbox() {
    final query = _viewQuery()
      ..where(_db.tasks.status.equals(TaskStatus.inbox.name));
    return query.watch().map((rows) => rows.map(_toView).toList());
  }

  /// Open tasks planned before [today] that were left over.
  Stream<List<TaskView>> watchOverdue(DateTime today) {
    final t = _db.tasks;
    final query = _viewQuery()
      ..where(
        t.status.isIn(_openNames) &
            t.plannedDay.isSmallerThanValue(_dayOf(today)),
      );
    return query.watch().map((rows) => rows.map(_toView).toList());
  }

  /// Waiting tasks whose follow-up date has been reached.
  Stream<List<TaskView>> watchFollowUpsDue(DateTime today) {
    final t = _db.tasks;
    final query = _viewQuery()
      ..where(
        t.status.equals(TaskStatus.waitingFor.name) &
            t.followUpDate.isSmallerThanValue(
              _dayOf(today).add(const Duration(days: 1)),
            ),
      );
    return query.watch().map((rows) => rows.map(_toView).toList());
  }

  /// Open tasks planned on [day], in the user's order.
  Stream<List<TaskView>> watchPlannedOn(DateTime day) {
    final t = _db.tasks;
    final from = _dayOf(day);
    final query = _viewQuery()
      ..where(
        t.status.isIn(_openNames) &
            t.plannedDay.isBiggerOrEqualValue(from) &
            t.plannedDay.isSmallerThanValue(from.add(const Duration(days: 1))),
      );
    return query.watch().map(
      (rows) => rows.map(_toView).toList()
        ..sort((a, b) {
          final o = a.task.order.compareTo(b.task.order);
          return o != 0 ? o : a.task.plannedDay!.compareTo(b.task.plannedDay!);
        }),
    );
  }

  /// Tasks marked done on [day].
  Stream<List<TaskView>> watchDoneOn(DateTime day) {
    final t = _db.tasks;
    final from = _dayOf(day);
    final query = _viewQuery()
      ..where(
        t.status.equals(TaskStatus.done.name) &
            t.updatedAt.isBiggerOrEqualValue(from) &
            t.updatedAt.isSmallerThanValue(from.add(const Duration(days: 1))),
      );
    return query.watch().map((rows) => rows.map(_toView).toList());
  }

  /// Tasks (open or done) carrying [tag].
  Stream<List<TaskView>> watchTagged(String tag) {
    final t = _db.tasks;
    final query = _viewQuery()
      ..where(
        t.status.isNotIn([TaskStatus.dropped.name]) &
            t.tags.like('%${jsonEncode(tag)}%'),
      );
    return query.watch().map(
      (rows) => rows.map(_toView).where((v) => v.tags.contains(tag)).toList(),
    );
  }

  /// Plans a task for [day]. Appointments keep their time of day; inbox
  /// items become planned.
  Future<void> planFor(String taskId, DateTime day) async {
    final task = await getTask(taskId);
    if (task == null) return;
    final keep = isAppointment(task)
        ? Duration(
            hours: task.plannedDay!.hour,
            minutes: task.plannedDay!.minute,
          )
        : Duration.zero;
    await saveTask(
      TasksCompanion(
        id: Value(taskId),
        plannedDay: Value(_dayOf(day).add(keep)),
        status: task.status == TaskStatus.inbox
            ? const Value(TaskStatus.planned)
            : const Value.absent(),
      ),
    );
  }

  /// Parks a task without a date.
  Future<void> moveToSomeday(String taskId) => saveTask(
    TasksCompanion(
      id: Value(taskId),
      status: const Value(TaskStatus.someday),
      plannedDay: const Value(null),
    ),
  );

  /// Stores the order of [orderedIds] (e.g. the plan for the day).
  Future<void> setOrder(List<String> orderedIds) => _db.transaction(() async {
    for (final (i, id) in orderedIds.indexed) {
      await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(order: Value(i), updatedAt: Value(DateTime.now())),
      );
    }
  });

  Future<void> removeTag(String taskId, String tag) async {
    final task = await getTask(taskId);
    if (task == null) return;
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        tags: Value(encodeTags(decodeTags(task.tags).where((x) => x != tag))),
      ),
    );
  }

  /// The next open task planned (or due) after [today].
  Stream<TaskView?> watchNextUp(DateTime today) {
    final t = _db.tasks;
    final nextDay = _dayOf(today).add(const Duration(days: 1));
    final when = coalesce([t.plannedDay, t.due]);
    final query = _viewQuery()
      ..where(
        t.status.isIn([
              TaskStatus.inbox.name,
              TaskStatus.planned.name,
              TaskStatus.waitingFor.name,
              TaskStatus.blocked.name,
            ]) &
            when.isBiggerOrEqualValue(nextDay),
      )
      ..orderBy([OrderingTerm(expression: when)])
      ..limit(1);
    return query.watch().map(
      (rows) => rows.isEmpty ? null : _toView(rows.first),
    );
  }

  Stream<TaskView?> watchTask(String id) {
    final query = _viewQuery()..where(_db.tasks.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toView(row),
    );
  }

  Future<Task?> getTask(String id) => (_db.select(
    _db.tasks,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();

  void _validate(TasksCompanion entry) {
    if (entry.title.present && entry.title.value.trim().isEmpty) {
      throw const TaskValidationException('Titel fehlt');
    }
    if (entry.status.present && entry.status.value == TaskStatus.waitingFor) {
      final who = entry.waitingFor.present ? entry.waitingFor.value : null;
      final followUp = entry.followUpDate.present
          ? entry.followUpDate.value
          : null;
      if (who == null || who.trim().isEmpty) {
        throw const TaskValidationException(
          'Bitte angeben, auf wen du wartest',
        );
      }
      if (followUp == null) {
        throw const TaskValidationException('Bitte ein Nachfass-Datum setzen');
      }
    }
  }

  /// Creates a task with an optional checklist. Returns the new id.
  Future<String> createTask(
    TasksCompanion entry, {
    List<ChecklistDraft> checklist = const [],
  }) {
    _validate(entry);
    return _db.transaction(() async {
      var e = entry;
      if (e.status.present &&
          e.status.value == TaskStatus.waitingFor &&
          !e.waitingSince.present) {
        e = e.copyWith(waitingSince: Value(DateTime.now()));
      }
      final id = (await _db.into(_db.tasks).insertReturning(e)).id;
      for (final (i, item) in checklist.indexed) {
        await _db
            .into(_db.checklistItems)
            .insert(
              ChecklistItemsCompanion.insert(
                taskId: id,
                label: item.label,
                required: Value(item.required),
                order: Value(i),
              ),
            );
      }
      return id;
    });
  }

  /// Quick capture: a task with only a title lands in the inbox.
  Future<String> capture(String title, {String? customerId}) => createTask(
    TasksCompanion.insert(title: title.trim(), customerId: Value(customerId)),
  );

  /// Creates a planned task for today from [template].
  Future<String> createFromTemplate(
    Template template, {
    String? customerId,
    String? projectId,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final effectiveCustomer = customerId ?? template.defaultCustomerId;
    String? customerName;
    if (effectiveCustomer != null) {
      final c = await (_db.select(
        _db.customers,
      )..where((t) => t.id.equals(effectiveCustomer))).getSingleOrNull();
      customerName = c?.name;
    }
    final title = renderTitle(
      template.titlePattern,
      customerName: customerName,
      date: today,
    );
    return createTask(
      TasksCompanion.insert(
        title: title.isEmpty ? template.name : title,
        status: const Value(TaskStatus.planned),
        plannedDay: Value(_dayOf(today)),
        customerId: Value(effectiveCustomer),
        projectId: Value(projectId),
        templateId: Value(template.id),
        estimateMin: Value(template.estimate),
      ),
      checklist: ChecklistDraft.decodeList(template.checklist),
    );
  }

  /// Updates an existing task. The companion must contain the `id`.
  Future<void> saveTask(TasksCompanion entry) async {
    _validate(entry);
    var e = entry.copyWith(updatedAt: Value(DateTime.now()));
    if (e.status.present && e.status.value == TaskStatus.waitingFor) {
      final current = await getTask(entry.id.value);
      if (current?.waitingSince == null || !e.waitingSince.present) {
        e = e.copyWith(
          waitingSince: Value(current?.waitingSince ?? DateTime.now()),
        );
      }
    } else if (e.status.present) {
      e = e.copyWith(
        waitingFor: const Value(null),
        waitingSince: const Value(null),
        followUpDate: const Value(null),
      );
    }
    await (_db.update(
      _db.tasks,
    )..where((t) => t.id.equals(entry.id.value))).write(e);
  }

  /// Marks a task done, or reopens it as planned.
  Future<void> setDone(String taskId, bool done) => saveTask(
    TasksCompanion(
      id: Value(taskId),
      status: Value(done ? TaskStatus.done : TaskStatus.planned),
    ),
  );

  Future<void> setStatus(String taskId, TaskStatus status) =>
      saveTask(TasksCompanion(id: Value(taskId), status: Value(status)));

  Future<void> deleteTask(String id) => _db.softDelete(_db.tasks, id);

  // Checklist

  Stream<List<ChecklistItem>> watchChecklist(String taskId) =>
      (_db.select(_db.checklistItems)
            ..where((t) => t.taskId.equals(taskId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.order)]))
          .watch();

  /// Required checklist items that are not done yet.
  Future<List<ChecklistItem>> openRequiredItems(String taskId) =>
      (_db.select(_db.checklistItems)..where(
            (t) =>
                t.taskId.equals(taskId) &
                t.deletedAt.isNull() &
                t.required.equals(true) &
                t.done.equals(false),
          ))
          .get();

  Future<void> _touch(String taskId) =>
      (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
        TasksCompanion(updatedAt: Value(DateTime.now())),
      );

  Future<void> addChecklistItem(
    String taskId,
    String label, {
    bool required = false,
  }) => _db.transaction(() async {
    final maxOrder = _db.checklistItems.order.max();
    final current =
        await (_db.selectOnly(_db.checklistItems)
              ..addColumns([maxOrder])
              ..where(_db.checklistItems.taskId.equals(taskId)))
            .map((r) => r.read(maxOrder))
            .getSingle();
    await _db
        .into(_db.checklistItems)
        .insert(
          ChecklistItemsCompanion.insert(
            taskId: taskId,
            label: label,
            required: Value(required),
            order: Value((current ?? -1) + 1),
          ),
        );
    await _touch(taskId);
  });

  Future<void> setChecklistDone(ChecklistItem item, bool done) =>
      _db.transaction(() async {
        final now = DateTime.now();
        await (_db.update(
          _db.checklistItems,
        )..where((t) => t.id.equals(item.id))).write(
          ChecklistItemsCompanion(
            done: Value(done),
            doneAt: Value(done ? now : null),
            updatedAt: Value(now),
          ),
        );
        await _touch(item.taskId);
      });

  Future<void> setChecklistRequired(ChecklistItem item, bool required) =>
      _db.transaction(() async {
        await (_db.update(
          _db.checklistItems,
        )..where((t) => t.id.equals(item.id))).write(
          ChecklistItemsCompanion(
            required: Value(required),
            updatedAt: Value(DateTime.now()),
          ),
        );
        await _touch(item.taskId);
      });

  Future<void> reorderChecklist(String taskId, List<String> orderedIds) =>
      _db.transaction(() async {
        final now = DateTime.now();
        for (var i = 0; i < orderedIds.length; i++) {
          await (_db.update(
            _db.checklistItems,
          )..where((t) => t.id.equals(orderedIds[i]))).write(
            ChecklistItemsCompanion(order: Value(i), updatedAt: Value(now)),
          );
        }
        await _touch(taskId);
      });

  Future<void> deleteChecklistItem(ChecklistItem item) =>
      _db.transaction(() async {
        await _db.softDelete(_db.checklistItems, item.id);
        await _touch(item.taskId);
      });
}

final tasksRepositoryProvider = Provider<TasksRepository>(
  (ref) => TasksRepository(ref.watch(databaseProvider)),
);

typedef TaskListArgs = ({
  TaskFilter filter,
  String? customerId,
  String? projectId,
});

final taskListProvider = StreamProvider.autoDispose
    .family<List<TaskView>, TaskListArgs>(
      (ref, args) => ref
          .watch(tasksRepositoryProvider)
          .watchTasks(
            filter: args.filter,
            customerId: args.customerId,
            projectId: args.projectId,
          ),
    );

final taskProvider = StreamProvider.autoDispose.family<TaskView?, String>(
  (ref, id) => ref.watch(tasksRepositoryProvider).watchTask(id),
);

final checklistProvider = StreamProvider.autoDispose
    .family<List<ChecklistItem>, String>(
      (ref, taskId) =>
          ref.watch(tasksRepositoryProvider).watchChecklist(taskId),
    );

final focusTasksProvider = StreamProvider.autoDispose
    .family<List<TaskView>, DateTime>(
      (ref, today) => ref.watch(tasksRepositoryProvider).watchFocus(today),
    );

final nextUpProvider = StreamProvider.autoDispose.family<TaskView?, DateTime>(
  (ref, today) => ref.watch(tasksRepositoryProvider).watchNextUp(today),
);

final dayAppointmentsProvider = StreamProvider.autoDispose
    .family<List<TaskView>, DateTime>(
      (ref, day) => ref.watch(tasksRepositoryProvider).watchAppointments(day),
    );
