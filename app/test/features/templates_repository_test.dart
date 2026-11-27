import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/templates/data/templates_repository.dart';

import '../helpers/test_database.dart';

void main() {
  group('renderTitle', () {
    final date = DateTime(2026, 2, 3);

    test('fills customer and date', () {
      expect(
        renderTitle(
          'Wartung {kunde} {datum}',
          customerName: 'Muster AG',
          date: date,
        ),
        'Wartung Muster AG 03.02.2026',
      );
    });

    test('drops missing values with dangling separators', () {
      expect(renderTitle('Drucker – {kunde}'), 'Drucker');
      expect(renderTitle('{kunde} – Drucker'), 'Drucker');
      expect(renderTitle('Netz - {kunde} - Prüfung'), 'Netz - Prüfung');
      expect(renderTitle('{kunde}'), '');
    });

    test('keeps ordinary text untouched', () {
      expect(
        renderTitle('E-Mail-Postfach einrichten'),
        'E-Mail-Postfach einrichten',
      );
    });
  });

  group('ChecklistDraft', () {
    test('round trip and tolerant decoding', () {
      const items = [ChecklistDraft('A', required: true), ChecklistDraft('B')];
      final decoded = ChecklistDraft.decodeList(
        ChecklistDraft.encodeList(items),
      );
      expect(decoded.map((d) => (d.label, d.required)), [
        ('A', true),
        ('B', false),
      ]);
      expect(ChecklistDraft.decodeList(null), isEmpty);
      expect(ChecklistDraft.decodeList('{nope'), isEmpty);
      expect(ChecklistDraft.decodeList('[{"label": ""}, 3]'), isEmpty);
    });
  });

  group('repository', () {
    late AppDatabase db;
    late TemplatesRepository repo;

    setUp(() {
      db = createTestDatabase();
      repo = TemplatesRepository(db);
    });
    tearDown(() => db.close());

    test('favorites first, filter, update and soft delete', () async {
      final a = await repo.saveTemplate(
        TemplatesCompanion.insert(name: 'Anruf', titlePattern: 'Anruf'),
      );
      await repo.saveTemplate(
        TemplatesCompanion.insert(
          name: 'Zugang',
          titlePattern: 'Zugang',
          isFavorite: const Value(true),
        ),
      );

      var all = await repo.watchTemplates().first;
      expect(all.map((t) => t.name), ['Zugang', 'Anruf']);
      expect(
        (await repo.watchTemplates(favoritesOnly: true).first).single.name,
        'Zugang',
      );

      await repo.setFavorite(a, true);
      await repo.saveTemplate(
        TemplatesCompanion(id: Value(a), name: const Value('Anruf kurz')),
      );
      all = await repo.watchTemplates().first;
      expect(all.map((t) => t.name), ['Anruf kurz', 'Zugang']);

      await repo.deleteTemplate(a);
      expect((await repo.watchTemplates().first).single.name, 'Zugang');
    });
  });
}
