import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

enum CustomerFilter {
  all('Alle'),
  favorites('Favoriten'),
  withOpen('Mit Offenem');

  const CustomerFilter(this.label);
  final String label;
}

/// Task states that count as closed.
const closedTaskStates = [TaskStatus.done, TaskStatus.dropped];

class CustomersRepository {
  CustomersRepository(this._db);

  final AppDatabase _db;

  Stream<List<Customer>> watchCustomers({
    String query = '',
    CustomerFilter filter = CustomerFilter.all,
  }) {
    final c = _db.customers;
    final select = _db.select(c)..where((t) => t.deletedAt.isNull());

    switch (filter) {
      case CustomerFilter.all:
        break;
      case CustomerFilter.favorites:
        select.where((t) => t.isFavorite.equals(true));
      case CustomerFilter.withOpen:
        select.where(
          (t) => existsQuery(
            _db.select(_db.tasks)..where(
              (task) =>
                  task.customerId.equalsExp(t.id) &
                  task.deletedAt.isNull() &
                  task.status.isNotIn(closedTaskStates.map((s) => s.name)),
            ),
          ),
        );
    }

    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      final pattern = '%$trimmed%';
      select.where(
        (t) =>
            t.name.like(pattern) |
            t.address.like(pattern) |
            existsQuery(
              _db.select(_db.contacts)..where(
                (k) =>
                    k.customerId.equalsExp(t.id) &
                    k.deletedAt.isNull() &
                    k.name.like(pattern),
              ),
            ),
      );
    }

    select.orderBy([
      (t) => OrderingTerm(expression: t.name.collate(Collate.noCase)),
    ]);
    return select.watch();
  }

  Stream<Customer?> watchCustomer(String id) => (_db.select(
    _db.customers,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).watchSingleOrNull();

  Future<Customer?> getCustomer(String id) => (_db.select(
    _db.customers,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();

  /// Inserts a new customer or updates the existing one if `id` is present.
  /// Returns the customer's id.
  Future<String> saveCustomer(CustomersCompanion entry) async {
    if (entry.id.present) {
      await (_db.update(_db.customers)
            ..where((t) => t.id.equals(entry.id.value)))
          .write(entry.copyWith(updatedAt: Value(DateTime.now())));
      return entry.id.value;
    }
    final row = await _db.into(_db.customers).insertReturning(entry);
    return row.id;
  }

  Future<void> setFavorite(String id, bool favorite) =>
      (_db.update(_db.customers)..where((t) => t.id.equals(id))).write(
        CustomersCompanion(
          isFavorite: Value(favorite),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> deleteCustomer(String id) => _db.softDelete(_db.customers, id);

  Stream<List<Contact>> watchContacts(String customerId) =>
      (_db.select(_db.contacts)
            ..where(
              (t) => t.customerId.equals(customerId) & t.deletedAt.isNull(),
            )
            ..orderBy([
              (t) => OrderingTerm(expression: t.name.collate(Collate.noCase)),
            ]))
          .watch();

  Future<void> saveContact(ContactsCompanion entry) async {
    if (entry.id.present) {
      await (_db.update(_db.contacts)
            ..where((t) => t.id.equals(entry.id.value)))
          .write(entry.copyWith(updatedAt: Value(DateTime.now())));
    } else {
      await _db.into(_db.contacts).insert(entry);
    }
  }

  Future<void> deleteContact(String id) => _db.softDelete(_db.contacts, id);
}

final customersRepositoryProvider = Provider<CustomersRepository>(
  (ref) => CustomersRepository(ref.watch(databaseProvider)),
);

typedef CustomerListArgs = ({String query, CustomerFilter filter});

final customerListProvider = StreamProvider.autoDispose
    .family<List<Customer>, CustomerListArgs>(
      (ref, args) => ref
          .watch(customersRepositoryProvider)
          .watchCustomers(query: args.query, filter: args.filter),
    );

final allCustomersProvider = StreamProvider.autoDispose<List<Customer>>(
  (ref) => ref.watch(customersRepositoryProvider).watchCustomers(),
);

final customerProvider = StreamProvider.autoDispose.family<Customer?, String>(
  (ref, id) => ref.watch(customersRepositoryProvider).watchCustomer(id),
);

final contactsProvider = StreamProvider.autoDispose
    .family<List<Contact>, String>(
      (ref, customerId) =>
          ref.watch(customersRepositoryProvider).watchContacts(customerId),
    );
