import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/customers/data/customers_repository.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late CustomersRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = CustomersRepository(db);
  });
  tearDown(() => db.close());

  Future<String> add(String name, {String? address, bool favorite = false}) =>
      repo.saveCustomer(
        CustomersCompanion.insert(
          name: name,
          address: Value(address),
          isFavorite: Value(favorite),
        ),
      );

  Future<List<String>> names({
    String query = '',
    CustomerFilter filter = CustomerFilter.all,
  }) async => (await repo.watchCustomers(query: query, filter: filter).first)
      .map((c) => c.name)
      .toList();

  test('lists active customers sorted by name, case-insensitive', () async {
    await add('muster AG');
    await add('Beispiel GmbH');
    final gone = await add('Alt KG');
    await repo.deleteCustomer(gone);

    expect(await names(), ['Beispiel GmbH', 'muster AG']);
  });

  test('search matches name, address and contact name', () async {
    final a = await add('Beispiel GmbH', address: 'Musterstraße 1, Berlin');
    await add('Muster AG', address: 'Hauptweg 2, Hamburg');
    await repo.saveContact(
      ContactsCompanion.insert(customerId: a, name: 'Erika Musterfrau'),
    );

    expect(await names(query: 'berlin'), ['Beispiel GmbH']);
    expect(await names(query: 'Hamburg'), ['Muster AG']);
    expect(await names(query: 'Erika'), ['Beispiel GmbH']);
    expect(await names(query: 'xyz'), isEmpty);
  });

  test('favorites filter and toggling', () async {
    await add('Beispiel GmbH', favorite: true);
    final b = await add('Muster AG');
    expect(await names(filter: CustomerFilter.favorites), ['Beispiel GmbH']);

    await repo.setFavorite(b, true);
    expect(await names(filter: CustomerFilter.favorites), hasLength(2));
  });

  test('open filter only lists customers with unfinished tasks', () async {
    final a = await add('Beispiel GmbH');
    final b = await add('Muster AG');
    await add('Ohne Aufgaben KG');
    await db
        .into(db.tasks)
        .insert(TasksCompanion.insert(title: 'Offen', customerId: Value(a)));
    await db
        .into(db.tasks)
        .insert(
          TasksCompanion.insert(
            title: 'Erledigt',
            customerId: Value(b),
            status: const Value(TaskStatus.done),
          ),
        );

    expect(await names(filter: CustomerFilter.withOpen), ['Beispiel GmbH']);
  });

  test('update keeps id and bumps updatedAt', () async {
    final id = await add('Beispiel GmbH');
    final before = (await repo.getCustomer(id))!;
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    await repo.saveCustomer(
      CustomersCompanion(id: Value(id), name: const Value('Beispiel AG')),
    );
    final after = (await repo.getCustomer(id))!;

    expect(after.name, 'Beispiel AG');
    expect(after.updatedAt.isAfter(before.updatedAt), isTrue);
    expect(after.createdAt, before.createdAt);
  });

  test('contacts are listed per customer and can be deleted', () async {
    final a = await add('Beispiel GmbH');
    await repo.saveContact(
      ContactsCompanion.insert(customerId: a, name: 'Max Mustermann'),
    );
    final contacts = await repo.watchContacts(a).first;
    expect(contacts.single.name, 'Max Mustermann');

    await repo.deleteContact(contacts.single.id);
    expect(await repo.watchContacts(a).first, isEmpty);
  });
}
