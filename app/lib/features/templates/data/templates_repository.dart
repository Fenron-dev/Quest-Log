import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/ui/formatting.dart';

/// One step of a template checklist.
class ChecklistDraft {
  const ChecklistDraft(this.label, {this.required = false});

  final String label;
  final bool required;

  Map<String, Object> toJson() => {'label': label, 'required': required};

  static ChecklistDraft fromJson(Map<String, dynamic> json) => ChecklistDraft(
    json['label'] as String? ?? '',
    required: json['required'] as bool? ?? false,
  );

  static String encodeList(List<ChecklistDraft> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<ChecklistDraft> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      return [
        for (final e in list)
          if (e is Map<String, dynamic>) ChecklistDraft.fromJson(e),
      ].where((d) => d.label.isNotEmpty).toList();
    } on FormatException {
      return const [];
    }
  }
}

/// Placeholders supported in template title patterns.
abstract final class TitlePlaceholders {
  static const customer = '{kunde}';
  static const date = '{datum}';
}

/// Fills the placeholders of [pattern]. Missing values are removed together
/// with dangling separators.
String renderTitle(String pattern, {String? customerName, DateTime? date}) {
  var title = pattern
      .replaceAll(TitlePlaceholders.customer, customerName ?? '')
      .replaceAll(TitlePlaceholders.date, date == null ? '' : formatDate(date));
  title = title
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp(r'^[\s\-–·:,]+|[\s\-–·:,]+$'), '')
      .replaceAllMapped(
        RegExp(r'\s*([\-–·:,])\s*([\-–·:,]\s*)+'),
        (m) => ' ${m[1]} ',
      )
      .trim();
  return title;
}

class TemplatesRepository {
  TemplatesRepository(this._db);

  final AppDatabase _db;

  Stream<List<Template>> watchTemplates({bool favoritesOnly = false}) {
    final select = _db.select(_db.templates)
      ..where((t) => t.deletedAt.isNull());
    if (favoritesOnly) select.where((t) => t.isFavorite.equals(true));
    select.orderBy([
      (t) => OrderingTerm.desc(t.isFavorite),
      (t) => OrderingTerm(expression: t.name.collate(Collate.noCase)),
    ]);
    return select.watch();
  }

  Future<Template?> getTemplate(String id) => (_db.select(
    _db.templates,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();

  Future<String> saveTemplate(TemplatesCompanion entry) async {
    if (entry.id.present) {
      await (_db.update(_db.templates)
            ..where((t) => t.id.equals(entry.id.value)))
          .write(entry.copyWith(updatedAt: Value(DateTime.now())));
      return entry.id.value;
    }
    return (await _db.into(_db.templates).insertReturning(entry)).id;
  }

  Future<void> setFavorite(String id, bool favorite) =>
      (_db.update(_db.templates)..where((t) => t.id.equals(id))).write(
        TemplatesCompanion(
          isFavorite: Value(favorite),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> deleteTemplate(String id) => _db.softDelete(_db.templates, id);
}

final templatesRepositoryProvider = Provider<TemplatesRepository>(
  (ref) => TemplatesRepository(ref.watch(databaseProvider)),
);

final templateListProvider = StreamProvider.autoDispose<List<Template>>(
  (ref) => ref.watch(templatesRepositoryProvider).watchTemplates(),
);

final favoriteTemplatesProvider = StreamProvider.autoDispose<List<Template>>(
  (ref) => ref
      .watch(templatesRepositoryProvider)
      .watchTemplates(favoritesOnly: true),
);
