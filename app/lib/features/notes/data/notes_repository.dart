import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

class NotesRepository {
  NotesRepository(this._db);

  final AppDatabase _db;

  Stream<List<Note>> watchNotes(NoteParentType type, String parentId) =>
      (_db.select(_db.notes)
            ..where(
              (n) =>
                  n.parentType.equals(type.name) &
                  n.parentId.equals(parentId) &
                  n.deletedAt.isNull(),
            )
            ..orderBy([(n) => OrderingTerm(expression: n.createdAt)]))
          .watch();

  Future<void> addText(
    NoteParentType type,
    String parentId,
    String text, {
    bool isSolution = false,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await _db
        .into(_db.notes)
        .insert(
          NotesCompanion.insert(
            parentType: type,
            parentId: parentId,
            body: Value(trimmed),
            isSolution: Value(isSolution),
          ),
        );
  }

  Future<void> setSolution(String id, bool isSolution) =>
      (_db.update(_db.notes)..where((n) => n.id.equals(id))).write(
        NotesCompanion(
          isSolution: Value(isSolution),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> delete(String id) => _db.softDelete(_db.notes, id);
}

final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => NotesRepository(ref.watch(databaseProvider)),
);

typedef NotesArgs = ({NoteParentType type, String parentId});

final notesProvider = StreamProvider.autoDispose.family<List<Note>, NotesArgs>(
  (ref, args) =>
      ref.watch(notesRepositoryProvider).watchNotes(args.type, args.parentId),
);
