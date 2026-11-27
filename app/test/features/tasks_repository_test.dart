import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/customers/data/customers_repository.dart';
import 'package:quest_log/features/tasks/data/tasks_repository.dart';
import 'package:quest_log/features/templates/data/templates_repository.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TasksRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = TasksRepository(db);
  });
  tearDown(() => db.close());

  Future<List<String>> titles([TaskFilter filter = TaskFilter.open]) async =>
      (await repo.watchTasks(filter: filter).first)
          .map((t) => t.task.title)
          .toList();

  group('capture and filters', () {
    test('quick capture lands in the inbox', () async {
      final id = await repo.capture('  Rückruf Drucker  ');
      final task = (await repo.getTask(id))!;
      expect(task.title, 'Rückruf Drucker');
      expect(task.status, TaskStatus.inbox);
      expect(await titles(TaskFilter.inbox), ['Rückruf Drucker']);
      expect(await titles(TaskFilter.open), ['Rückruf Drucker']);
    });

    test('empty title is rejected', () {
      expect(
        () => repo.capture('   '),
        throwsA(isA<TaskValidationException>()),
      );
    });

    test(
      'filters by status group, customer and sorts important first',
      () async {
        final customer = await CustomersRepository(db)
            .saveCustomer(CustomersCompanion.insert(name: 'Beispiel GmbH'));
        await repo.createTask(
          TasksCompanion.insert(
            title: 'Normal',
            status: const Value(TaskStatus.planned),
          ),
        );
        await repo.createTask(
          TasksCompanion.insert(
            title: 'Wichtig',
            important: const Value(true),
            customerId: Value(customer),
          ),
        );
        await repo.createTask(
          TasksCompanion.insert(
            title: 'Später',
            status: const Value(TaskStatus.someday),
          ),
        );
        final done = await repo.capture('Fertig');
        await repo.setDone(done, true);

        expect(await titles(), ['Wichtig', 'Normal']);
        expect(await titles(TaskFilter.someday), ['Später']);
        expect(await titles(TaskFilter.closed), ['Fertig']);

        final forCustomer = await repo.watchTasks(customerId: customer).first;
        expect(forCustomer.single.customer?.name, 'Beispiel GmbH');
      },
    );

    test('reopening a done task makes it planned', () async {
      final id = await repo.capture('Aufgabe');
      await repo.setDone(id, true);
      await repo.setDone(id, false);
      expect((await repo.getTask(id))!.status, TaskStatus.planned);
    });

    test('soft-deleted tasks are hidden', () async {
      final id = await repo.capture('Weg');
      await repo.deleteTask(id);
      expect(await titles(), isEmpty);
    });
  });

  group('waiting for', () {
    test('requires who and follow-up date', () async {
      final id = await repo.capture('Angebot');
      expect(
        () => repo.setStatus(id, TaskStatus.waitingFor),
        throwsA(isA<TaskValidationException>()),
      );
      expect(
        () => repo.saveTask(
          TasksCompanion(
            id: Value(id),
            status: const Value(TaskStatus.waitingFor),
            waitingFor: const Value('Lieferant'),
          ),
        ),
        throwsA(isA<TaskValidationException>()),
      );
    });

    test('sets waitingSince, follow-up flag and clears on leaving', () async {
      final id = await repo.capture('Angebot');
      final followUp = DateTime(2026, 3, 10);
      await repo.saveTask(
        TasksCompanion(
          id: Value(id),
          status: const Value(TaskStatus.waitingFor),
          waitingFor: const Value('Lieferant'),
          followUpDate: Value(followUp),
        ),
      );
      var view = (await repo.watchTask(id).first)!;
      expect(view.task.waitingSince, isNotNull);
      expect(view.needsFollowUp(DateTime(2026, 3, 9)), isFalse);
      expect(view.needsFollowUp(DateTime(2026, 3, 10, 18)), isTrue);
      expect(await titles(TaskFilter.waiting), ['Angebot']);

      await repo.setStatus(id, TaskStatus.planned);
      view = (await repo.watchTask(id).first)!;
      expect(view.task.waitingFor, isNull);
      expect(view.task.followUpDate, isNull);
    });
  });

  group('checklist', () {
    test('add, check, reorder, required and counts', () async {
      final id = await repo.capture('Arbeitsplatz');
      await repo.addChecklistItem(id, 'Benutzer anlegen', required: true);
      await repo.addChecklistItem(id, 'Drucker verbinden');
      await repo.addChecklistItem(id, 'Übergabe');

      var items = await repo.watchChecklist(id).first;
      expect(items.map((i) => i.label), [
        'Benutzer anlegen',
        'Drucker verbinden',
        'Übergabe',
      ]);
      expect(await repo.openRequiredItems(id), hasLength(1));

      await repo.setChecklistDone(items[0], true);
      final checked = (await repo.watchChecklist(id).first).first;
      expect(checked.done, isTrue);
      expect(checked.doneAt, isNotNull);
      expect(await repo.openRequiredItems(id), isEmpty);

      var view = (await repo.watchTask(id).first)!;
      expect((view.checklistDone, view.checklistTotal), (1, 3));

      await repo.reorderChecklist(id, [items[2].id, items[0].id, items[1].id]);
      items = await repo.watchChecklist(id).first;
      expect(items.first.label, 'Übergabe');

      await repo.setChecklistRequired(items.first, true);
      expect(await repo.openRequiredItems(id), hasLength(1));

      await repo.deleteChecklistItem(items.last);
      view = (await repo.watchTask(id).first)!;
      expect(view.checklistTotal, 2);
    });
  });

  group('templates', () {
    test('creates a planned task with title, checklist and customer', () async {
      final customer = await CustomersRepository(db)
          .saveCustomer(CustomersCompanion.insert(name: 'Muster AG'));
      final templates = TemplatesRepository(db);
      final templateId = await templates.saveTemplate(
        TemplatesCompanion.insert(
          name: 'Drucker einrichten',
          titlePattern: 'Drucker einrichten – {kunde}',
          estimate: const Value(30),
          checklist: Value(
            ChecklistDraft.encodeList(const [
              ChecklistDraft('Treiber installieren', required: true),
              ChecklistDraft('Testseite drucken'),
            ]),
          ),
        ),
      );
      final template = (await templates.getTemplate(templateId))!;

      final id = await repo.createFromTemplate(
        template,
        customerId: customer,
        now: DateTime(2026, 2, 3, 9, 30),
      );
      final task = (await repo.getTask(id))!;
      expect(task.title, 'Drucker einrichten – Muster AG');
      expect(task.status, TaskStatus.planned);
      expect(task.plannedDay, DateTime(2026, 2, 3));
      expect(task.estimateMin, 30);
      expect(task.templateId, templateId);
      expect(task.customerId, customer);

      final items = await repo.watchChecklist(id).first;
      expect(items.map((i) => (i.label, i.required)), [
        ('Treiber installieren', true),
        ('Testseite drucken', false),
      ]);
    });

    test('falls back to the default customer of the template', () async {
      final customer = await CustomersRepository(db)
          .saveCustomer(CustomersCompanion.insert(name: 'Beispiel GmbH'));
      final templates = TemplatesRepository(db);
      final template = (await templates.getTemplate(
        await templates.saveTemplate(
          TemplatesCompanion.insert(
            name: 'Wartung',
            titlePattern: 'Wartung {kunde}',
            defaultCustomerId: Value(customer),
          ),
        ),
      ))!;
      final id = await repo.createFromTemplate(template);
      expect((await repo.getTask(id))!.title, 'Wartung Beispiel GmbH');
    });
  });

  test('tags round trip', () {
    expect(decodeTags(encodeTags([' netz ', 'drucker', '', 'netz'])), [
      'netz',
      'drucker',
    ]);
    expect(encodeTags(['  ']), isNull);
    expect(decodeTags('kaputt'), isEmpty);
  });
}
