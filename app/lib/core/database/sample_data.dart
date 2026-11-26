import 'package:drift/drift.dart';

import 'app_database.dart';

/// Inserts fictitious example records for trying out the app.
/// All names, addresses and numbers are made up.
Future<void> insertSampleData(AppDatabase db) => db.transaction(() async {
  Future<String> customer(
    String name, {
    required int color,
    String? address,
    int? contingent,
    bool favorite = false,
  }) async =>
      (await db
              .into(db.customers)
              .insertReturning(
                CustomersCompanion.insert(
                  name: name,
                  color: Value(color),
                  address: Value(address),
                  contingentAePerMonth: Value(contingent),
                  isFavorite: Value(favorite),
                ),
              ))
          .id;

  Future<void> contact(
    String customerId,
    String name, {
    String? role,
    String? phone,
    String? email,
  }) => db
      .into(db.contacts)
      .insert(
        ContactsCompanion.insert(
          customerId: customerId,
          name: name,
          role: Value(role),
          phone: Value(phone),
          email: Value(email),
        ),
      );

  Future<String> project(
    String name, {
    String? customerId,
    int? color,
    ProjectStatus status = ProjectStatus.active,
    int? budget,
    DateTime? start,
    DateTime? due,
    List<(String, bool)> milestones = const [],
    List<(String, bool)> criteria = const [],
  }) async {
    final id =
        (await db
                .into(db.projects)
                .insertReturning(
                  ProjectsCompanion.insert(
                    name: name,
                    customerId: Value(customerId),
                    color: Value(color),
                    status: Value(status),
                    budgetAe: Value(budget),
                    start: Value(start),
                    due: Value(due),
                  ),
                ))
            .id;
    for (final (i, (title, done)) in milestones.indexed) {
      await db
          .into(db.milestones)
          .insert(
            MilestonesCompanion.insert(
              projectId: id,
              title: title,
              order: Value(i),
              status: Value(done ? MilestoneStatus.done : MilestoneStatus.open),
            ),
          );
    }
    for (final (label, done) in criteria) {
      await db
          .into(db.criteria)
          .insert(
            CriteriaCompanion.insert(
              projectId: id,
              label: label,
              done: Value(done),
            ),
          );
    }
    return id;
  }

  Future<void> task(String title, String customerId) => db
      .into(db.tasks)
      .insert(
        TasksCompanion.insert(title: title, customerId: Value(customerId)),
      );

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final beispiel = await customer(
    'Beispiel GmbH',
    color: 0xFF1D5FD1,
    address: 'Musterstraße 1\n10115 Berlin',
    contingent: 20,
    favorite: true,
  );
  final muster = await customer(
    'Muster AG',
    color: 0xFF2E7D32,
    address: 'Beispielweg 5\n20095 Hamburg',
    favorite: true,
  );
  final praxis = await customer(
    'Praxis Dr. Demo',
    color: 0xFFC2570C,
    address: 'Am Testplatz 3\n80331 München',
    contingent: 10,
  );
  final kanzlei = await customer(
    'Kanzlei Fiktiv & Partner',
    color: 0xFF7B3FBF,
    address: 'Platzhalterallee 12\n50667 Köln',
  );
  await customer('Bäckerei Probe', color: 0xFFB7860B);

  await contact(
    beispiel,
    'Erika Musterfrau',
    role: 'Geschäftsführung',
    phone: '+49 30 1234567',
    email: 'erika@example.com',
  );
  await contact(beispiel, 'Max Mustermann', role: 'Empfang');
  await contact(muster, 'Anna Beispiel', role: 'IT-Ansprechpartnerin');
  await contact(praxis, 'Dr. Demo', email: 'praxis@example.com');

  await project(
    'Serverumzug',
    customerId: beispiel,
    budget: 60,
    start: today.subtract(const Duration(days: 14)),
    due: today.add(const Duration(days: 21)),
    milestones: [
      ('Bestandsaufnahme', true),
      ('Neue Hardware einrichten', true),
      ('Daten migrieren', false),
      ('Altsystem abschalten', false),
    ],
    criteria: [
      ('Alle Arbeitsplätze greifen auf den neuen Server zu', false),
      ('Datensicherung läuft', false),
    ],
  );
  await project(
    'WLAN-Erneuerung',
    customerId: muster,
    status: ProjectStatus.planned,
    budget: 24,
    milestones: [('Ausleuchtung', false), ('Access Points montieren', false)],
  );
  await project(
    'Praxissoftware-Update',
    customerId: praxis,
    color: 0xFFC62828,
    status: ProjectStatus.paused,
    milestones: [('Testlauf', true), ('Update einspielen', false)],
  );
  await project(
    'Dokumentation aufräumen',
    color: 0xFF64748B,
    milestones: [
      ('Vorlagen sichten', true),
      ('Kundenakten vereinheitlichen', false),
    ],
  );
  await project(
    'Eigenes Netzwerk-Monitoring',
    color: 0xFF0E7C7B,
    status: ProjectStatus.planned,
  );

  await task('Drucker im Empfang prüfen', beispiel);
  await task('Lizenzen verlängern', kanzlei);
});
