import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

extension ProjectStatusLabel on ProjectStatus {
  String get label => switch (this) {
    ProjectStatus.planned => 'Geplant',
    ProjectStatus.active => 'Aktiv',
    ProjectStatus.paused => 'Pausiert',
    ProjectStatus.fulfilled => 'Erfüllt',
    ProjectStatus.cancelled => 'Abgebrochen',
  };
}

class ProjectOverview {
  const ProjectOverview({
    required this.project,
    required this.customer,
    required this.milestonesDone,
    required this.milestonesTotal,
  });

  final Project project;
  final Customer? customer;
  final int milestonesDone;
  final int milestonesTotal;

  bool get isInternal => project.customerId == null;

  /// The project's own colour, or the customer's colour if none is set.
  int? get color => project.color ?? customer?.color;

  double? get progress =>
      milestonesTotal == 0 ? null : milestonesDone / milestonesTotal;
}

class ProjectsRepository {
  ProjectsRepository(this._db);

  final AppDatabase _db;

  Stream<List<ProjectOverview>> watchProjects({String? customerId}) {
    final query = _overviewQuery();
    if (customerId != null) {
      query.where(_db.projects.customerId.equals(customerId));
    }
    return query.watch().map((rows) => rows.map(_toOverview).toList());
  }

  Stream<ProjectOverview?> watchProject(String id) {
    final query = _overviewQuery()..where(_db.projects.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toOverview(row),
    );
  }

  Future<Project?> getProject(String id) => (_db.select(
    _db.projects,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();

  late final _milestonesTotal = _milestoneCount(onlyDone: false);
  late final _milestonesDone = _milestoneCount(onlyDone: true);

  Expression<int> _milestoneCount({required bool onlyDone}) {
    final m = _db.milestones;
    var filter = m.projectId.equalsExp(_db.projects.id) & m.deletedAt.isNull();
    if (onlyDone) filter &= m.status.equals(MilestoneStatus.done.name);
    return subqueryExpression<int>(
      _db.selectOnly(m)
        ..addColumns([countAll()])
        ..where(filter),
    );
  }

  JoinedSelectStatement<HasResultSet, dynamic> _overviewQuery() {
    final p = _db.projects;
    final c = _db.customers;
    return _db.select(p).join([
        leftOuterJoin(c, c.id.equalsExp(p.customerId) & c.deletedAt.isNull()),
      ])
      ..addColumns([_milestonesTotal, _milestonesDone])
      ..where(p.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: p.name.collate(Collate.noCase))]);
  }

  ProjectOverview _toOverview(TypedResult row) => ProjectOverview(
    project: row.readTable(_db.projects),
    customer: row.readTableOrNull(_db.customers),
    milestonesTotal: row.read(_milestonesTotal) ?? 0,
    milestonesDone: row.read(_milestonesDone) ?? 0,
  );

  /// Inserts a new project or updates the existing one if `id` is present.
  /// Returns the project's id.
  Future<String> saveProject(ProjectsCompanion entry) async {
    if (entry.id.present) {
      await (_db.update(_db.projects)
            ..where((t) => t.id.equals(entry.id.value)))
          .write(entry.copyWith(updatedAt: Value(DateTime.now())));
      return entry.id.value;
    }
    final row = await _db.into(_db.projects).insertReturning(entry);
    return row.id;
  }

  Future<void> deleteProject(String id) => _db.softDelete(_db.projects, id);

  /// Bumps `updatedAt` so watchers of the project list see child changes.
  Future<void> _touch(String projectId, {ProjectStatus? status}) =>
      (_db.update(_db.projects)..where((t) => t.id.equals(projectId))).write(
        ProjectsCompanion(
          updatedAt: Value(DateTime.now()),
          status: status == null ? const Value.absent() : Value(status),
        ),
      );

  // Milestones

  Stream<List<Milestone>> watchMilestones(String projectId) =>
      (_db.select(_db.milestones)
            ..where((t) => t.projectId.equals(projectId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.order)]))
          .watch();

  Future<void> addMilestone(String projectId, String title) =>
      _db.transaction(() async {
        final maxOrder = _db.milestones.order.max();
        final current =
            await (_db.selectOnly(_db.milestones)
                  ..addColumns([maxOrder])
                  ..where(_db.milestones.projectId.equals(projectId)))
                .map((r) => r.read(maxOrder))
                .getSingle();
        await _db
            .into(_db.milestones)
            .insert(
              MilestonesCompanion.insert(
                projectId: projectId,
                title: title,
                order: Value((current ?? -1) + 1),
              ),
            );
        await _touch(projectId);
      });

  Future<void> setMilestoneDone(Milestone milestone, bool done) =>
      _db.transaction(() async {
        await (_db.update(
          _db.milestones,
        )..where((t) => t.id.equals(milestone.id))).write(
          MilestonesCompanion(
            status: Value(done ? MilestoneStatus.done : MilestoneStatus.open),
            updatedAt: Value(DateTime.now()),
          ),
        );
        await _touch(milestone.projectId);
      });

  Future<void> reorderMilestones(String projectId, List<String> orderedIds) =>
      _db.transaction(() async {
        final now = DateTime.now();
        for (var i = 0; i < orderedIds.length; i++) {
          await (_db.update(
            _db.milestones,
          )..where((t) => t.id.equals(orderedIds[i]))).write(
            MilestonesCompanion(order: Value(i), updatedAt: Value(now)),
          );
        }
        await _touch(projectId);
      });

  Future<void> deleteMilestone(Milestone milestone) =>
      _db.transaction(() async {
        await _db.softDelete(_db.milestones, milestone.id);
        await _touch(milestone.projectId);
      });

  // Completion criteria

  Stream<List<Criterion>> watchCriteria(String projectId) =>
      (_db.select(_db.criteria)
            ..where((t) => t.projectId.equals(projectId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .watch();

  Future<void> addCriterion(String projectId, String label) => _db.transaction(
    () async {
      await _db
          .into(_db.criteria)
          .insert(CriteriaCompanion.insert(projectId: projectId, label: label));
      await _syncFulfilled(projectId);
    },
  );

  Future<void> setCriterionDone(Criterion criterion, bool done) =>
      _db.transaction(() async {
        await (_db.update(
          _db.criteria,
        )..where((t) => t.id.equals(criterion.id))).write(
          CriteriaCompanion(
            done: Value(done),
            updatedAt: Value(DateTime.now()),
          ),
        );
        await _syncFulfilled(criterion.projectId);
      });

  Future<void> deleteCriterion(Criterion criterion) =>
      _db.transaction(() async {
        await _db.softDelete(_db.criteria, criterion.id);
        await _syncFulfilled(criterion.projectId);
      });

  /// A project is fulfilled once all of its completion criteria are met.
  /// Moves the status to fulfilled or back to active accordingly.
  Future<void> _syncFulfilled(String projectId) async {
    final project = await getProject(projectId);
    if (project == null) return;
    final criteria =
        await (_db.select(_db.criteria)..where(
              (t) => t.projectId.equals(projectId) & t.deletedAt.isNull(),
            ))
            .get();
    final allDone = criteria.isNotEmpty && criteria.every((c) => c.done);

    ProjectStatus? next;
    if (allDone &&
        project.status != ProjectStatus.fulfilled &&
        project.status != ProjectStatus.cancelled) {
      next = ProjectStatus.fulfilled;
    } else if (!allDone && project.status == ProjectStatus.fulfilled) {
      next = ProjectStatus.active;
    }
    await _touch(projectId, status: next);
  }
}

final projectsRepositoryProvider = Provider<ProjectsRepository>(
  (ref) => ProjectsRepository(ref.watch(databaseProvider)),
);

final projectListProvider = StreamProvider.autoDispose
    .family<List<ProjectOverview>, String?>(
      (ref, customerId) => ref
          .watch(projectsRepositoryProvider)
          .watchProjects(customerId: customerId),
    );

final projectProvider = StreamProvider.autoDispose
    .family<ProjectOverview?, String>(
      (ref, id) => ref.watch(projectsRepositoryProvider).watchProject(id),
    );

final milestonesProvider = StreamProvider.autoDispose
    .family<List<Milestone>, String>(
      (ref, projectId) =>
          ref.watch(projectsRepositoryProvider).watchMilestones(projectId),
    );

final criteriaProvider = StreamProvider.autoDispose
    .family<List<Criterion>, String>(
      (ref, projectId) =>
          ref.watch(projectsRepositoryProvider).watchCriteria(projectId),
    );
