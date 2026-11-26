import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/customers/data/customers_repository.dart';
import 'package:quest_log/features/projects/data/projects_repository.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ProjectsRepository repo;
  late String customerId;

  setUp(() async {
    db = createTestDatabase();
    repo = ProjectsRepository(db);
    customerId = await CustomersRepository(db).saveCustomer(
      CustomersCompanion.insert(
        name: 'Beispiel GmbH',
        color: const Value(0xFF2E7D32),
      ),
    );
  });
  tearDown(() => db.close());

  Future<String> addProject(String name, {String? customer, int? color}) =>
      repo.saveProject(
        ProjectsCompanion.insert(
          name: name,
          customerId: Value(customer),
          color: Value(color),
        ),
      );

  test('overview joins customer and inherits its colour', () async {
    await addProject('Intern', color: 0xFF64748B);
    await addProject('Serverumzug', customer: customerId);

    final list = await repo.watchProjects().first;
    expect(list.map((p) => p.project.name), ['Intern', 'Serverumzug']);

    final internal = list.first;
    expect(internal.isInternal, isTrue);
    expect(internal.color, 0xFF64748B);

    final customerProject = list.last;
    expect(customerProject.customer?.name, 'Beispiel GmbH');
    expect(customerProject.color, 0xFF2E7D32);
  });

  test('filters by customer and hides deleted projects', () async {
    await addProject('Intern');
    final p = await addProject('Serverumzug', customer: customerId);
    await addProject('Netzwerk', customer: customerId);

    expect(
      await repo.watchProjects(customerId: customerId).first,
      hasLength(2),
    );
    await repo.deleteProject(p);
    final names = (await repo.watchProjects().first).map((e) => e.project.name);
    expect(names, ['Intern', 'Netzwerk']);
  });

  test('milestone progress, order and reordering', () async {
    final p = await addProject('Serverumzug', customer: customerId);
    await repo.addMilestone(p, 'Planung');
    await repo.addMilestone(p, 'Umzug');
    await repo.addMilestone(p, 'Abnahme');

    var milestones = await repo.watchMilestones(p).first;
    expect(milestones.map((m) => m.title), ['Planung', 'Umzug', 'Abnahme']);

    await repo.setMilestoneDone(milestones.first, true);
    var overview = (await repo.watchProject(p).first)!;
    expect(overview.milestonesDone, 1);
    expect(overview.milestonesTotal, 3);
    expect(overview.progress, closeTo(1 / 3, 1e-9));

    await repo.reorderMilestones(p, [
      milestones[2].id,
      milestones[0].id,
      milestones[1].id,
    ]);
    milestones = await repo.watchMilestones(p).first;
    expect(milestones.map((m) => m.title), ['Abnahme', 'Planung', 'Umzug']);

    await repo.deleteMilestone(milestones.first);
    overview = (await repo.watchProject(p).first)!;
    expect(overview.milestonesTotal, 2);
  });

  test('project list stream updates when milestones change', () async {
    final p = await addProject('Serverumzug', customer: customerId);
    final emissions = <int>[];
    final sub = repo.watchProjects().listen(
      (list) => emissions.add(list.single.milestonesTotal),
    );
    await pumpEventQueue();
    await repo.addMilestone(p, 'Planung');
    await pumpEventQueue();
    await sub.cancel();

    expect(emissions.first, 0);
    expect(emissions.last, 1);
  });

  test('all criteria met marks the project fulfilled and back', () async {
    final p = await addProject('Serverumzug', customer: customerId);
    await repo.saveProject(
      ProjectsCompanion(
        id: Value(p),
        status: const Value(ProjectStatus.active),
      ),
    );
    await repo.addCriterion(p, 'Alle Clients migriert');
    await repo.addCriterion(p, 'Altsystem abgeschaltet');

    final criteria = await repo.watchCriteria(p).first;
    await repo.setCriterionDone(criteria[0], true);
    expect((await repo.getProject(p))!.status, ProjectStatus.active);

    await repo.setCriterionDone(criteria[1], true);
    expect((await repo.getProject(p))!.status, ProjectStatus.fulfilled);

    await repo.setCriterionDone(criteria[1], false);
    expect((await repo.getProject(p))!.status, ProjectStatus.active);
  });

  test('cancelled projects stay cancelled when criteria are met', () async {
    final p = await addProject('Serverumzug');
    await repo.saveProject(
      ProjectsCompanion(
        id: Value(p),
        status: const Value(ProjectStatus.cancelled),
      ),
    );
    await repo.addCriterion(p, 'Kriterium');
    final c = (await repo.watchCriteria(p).first).single;
    await repo.setCriterionDone(c, true);
    expect((await repo.getProject(p))!.status, ProjectStatus.cancelled);
  });
}
