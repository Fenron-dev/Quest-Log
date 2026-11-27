import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/sample_data.dart';
import 'package:quest_log/features/customers/data/customers_repository.dart';
import 'package:quest_log/features/projects/data/projects_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  test('sample data fills customers, contacts and projects', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    await insertSampleData(db);

    final customers = await CustomersRepository(db).watchCustomers().first;
    expect(customers.length, greaterThanOrEqualTo(4));
    expect(customers.where((c) => c.isFavorite), isNotEmpty);

    final open = await CustomersRepository(
      db,
    ).watchCustomers(filter: CustomerFilter.withOpen).first;
    expect(open, isNotEmpty);

    final projects = await ProjectsRepository(db).watchProjects().first;
    expect(projects.where((p) => p.isInternal), isNotEmpty);
    expect(projects.where((p) => !p.isInternal), isNotEmpty);
    expect(projects.where((p) => p.milestonesTotal > 0), isNotEmpty);
  });
}
