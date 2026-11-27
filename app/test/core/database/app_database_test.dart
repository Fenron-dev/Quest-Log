import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  Future<Customer> insertCustomer([String name = 'Beispiel GmbH']) => db
      .into(db.customers)
      .insertReturning(CustomersCompanion.insert(name: name));

  group('sync columns', () {
    test('new rows get a UUID and timestamps, no deletedAt', () async {
      final customer = await insertCustomer();

      expect(
        customer.id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
      expect(customer.createdAt, isNotNull);
      expect(customer.updatedAt, isNotNull);
      expect(customer.deletedAt, isNull);
    });

    test('UUIDs are unique', () {
      final ids = {for (var i = 0; i < 1000; i++) newUuid()};
      expect(ids, hasLength(1000));
    });
  });

  group('create and read', () {
    test('customer with contact', () async {
      final customer = await insertCustomer();
      await db
          .into(db.contacts)
          .insert(
            ContactsCompanion.insert(
              customerId: customer.id,
              name: 'Erika Musterfrau',
              phone: const Value('+49 30 1234567'),
              email: const Value('erika@example.com'),
            ),
          );

      final read = await (db.select(
        db.customers,
      )..where((t) => t.id.equals(customer.id))).getSingle();
      final contacts = await db.select(db.contacts).get();

      expect(read.name, 'Beispiel GmbH');
      expect(read.isFavorite, isFalse);
      expect(contacts.single.customerId, customer.id);
      expect(contacts.single.email, 'erika@example.com');
    });

    test('project defaults and enum round trip', () async {
      final customer = await insertCustomer();
      final project = await db
          .into(db.projects)
          .insertReturning(
            ProjectsCompanion.insert(
              name: 'Serverumzug',
              customerId: Value(customer.id),
              budgetAe: const Value(60),
            ),
          );
      expect(project.status, ProjectStatus.planned);

      await (db.update(db.projects)..where((t) => t.id.equals(project.id)))
          .write(const ProjectsCompanion(status: Value(ProjectStatus.active)));

      final read = await (db.select(
        db.projects,
      )..where((t) => t.id.equals(project.id))).getSingle();
      expect(read.status, ProjectStatus.active);
      expect(read.budgetAe, 60);
    });

    test('internal project has no customer', () async {
      final project = await db
          .into(db.projects)
          .insertReturning(ProjectsCompanion.insert(name: 'Intern'));
      expect(project.customerId, isNull);
    });

    test('task with checklist and time entry', () async {
      final customer = await insertCustomer();
      final task = await db
          .into(db.tasks)
          .insertReturning(
            TasksCompanion.insert(
              title: 'Drucker einrichten',
              customerId: Value(customer.id),
              source: const Value(TaskSource.phone),
            ),
          );
      await db
          .into(db.checklistItems)
          .insert(
            ChecklistItemsCompanion.insert(taskId: task.id, label: 'Treiber'),
          );
      final start = DateTime(2026, 1, 5, 9);
      await db
          .into(db.timeEntries)
          .insert(
            TimeEntriesCompanion.insert(
              start: start,
              end: Value(start.add(const Duration(minutes: 25))),
              taskId: Value(task.id),
              kind: const Value(TimeEntryKind.background),
            ),
          );

      expect(task.status, TaskStatus.inbox);
      final items = await db.select(db.checklistItems).get();
      expect(items.single.done, isFalse);
      final entry = await db.select(db.timeEntries).getSingle();
      expect(entry.kind, TimeEntryKind.background);
      expect(entry.end!.difference(entry.start).inMinutes, 25);
      expect(entry.billable, isTrue);
    });

    test('note attached to a customer', () async {
      final customer = await insertCustomer();
      await db
          .into(db.notes)
          .insert(
            NotesCompanion.insert(
              parentType: NoteParentType.customer,
              parentId: customer.id,
              body: const Value('Testnotiz'),
            ),
          );
      final note = await db.select(db.notes).getSingle();
      expect(note.type, NoteType.text);
      expect(note.parentId, customer.id);
    });

    test('foreign keys are enforced', () async {
      expect(
        db
            .into(db.contacts)
            .insert(
              ContactsCompanion.insert(customerId: newUuid(), name: 'Niemand'),
            ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('soft delete', () {
    test('marks row as deleted and hides it from active selects', () async {
      final a = await insertCustomer('Beispiel GmbH');
      final b = await insertCustomer('Muster AG');

      final affected = await db.softDelete(db.customers, a.id);
      expect(affected, 1);

      final active = await db.selectActive(db.customers).get();
      expect(active.map((c) => c.id), [b.id]);

      final all = await db.select(db.customers).get();
      expect(all, hasLength(2));
      final deleted = all.firstWhere((c) => c.id == a.id);
      expect(deleted.deletedAt, isNotNull);
      expect(deleted.updatedAt.isBefore(a.updatedAt), isFalse);
    });

    test('is idempotent', () async {
      final a = await insertCustomer();
      expect(await db.softDelete(db.customers, a.id), 1);
      expect(await db.softDelete(db.customers, a.id), 0);
    });

    test('works for other tables', () async {
      final task = await db
          .into(db.tasks)
          .insertReturning(TasksCompanion.insert(title: 'Aufgabe'));
      await db.softDelete(db.tasks, task.id);
      expect(await db.selectActive(db.tasks).get(), isEmpty);
    });
  });

  group('settings', () {
    test('write, overwrite and read', () async {
      expect(await db.readSetting('theme'), isNull);
      await db.writeSetting('theme', 'dark');
      await db.writeSetting('theme', 'warm');
      expect(await db.readSetting('theme'), 'warm');
    });
  });
}
