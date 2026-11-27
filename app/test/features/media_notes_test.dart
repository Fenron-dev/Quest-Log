import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/notes/media/media_store.dart';

import '../helpers/fake_media.dart';
import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

Finder labelled(String label) => find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == label,
);

void main() {
  late AppDatabase db;
  late MediaStore store;
  late FakeMediaCapture capture;

  setUp(() {
    db = createTestDatabase();
    store = tempMediaStore();
    capture = FakeMediaCapture();
  });

  Future<List<Note>> notes(WidgetTester tester) async =>
      (await tester.runAsync(() => db.select(db.notes).get()))!;

  Future<bool> stored(WidgetTester tester, String name) async =>
      (await tester.runAsync(() async => (await store.file(name)).exists()))!;

  Future<void> openTask(WidgetTester tester) async {
    await tester.runAsync(
      () => db
          .into(db.tasks)
          .insert(
            TasksCompanion.insert(
              title: 'Drucker einrichten',
              status: const Value(TaskStatus.planned),
            ),
          ),
    );
    await pumpTestApp(tester, db, media: store, capture: capture);
    await tester.tap(navItem('Aufgaben'));
    await settleAsync(tester);
    await tester.longPress(find.text('Drucker einrichten'));
    await settleAsync(tester);
    await tester.scrollUntilVisible(
      find.byTooltip('Notiz speichern'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('photo from the camera becomes a note with a stored file', (
    tester,
  ) async {
    await openTask(tester);
    capture.next = FakeMediaCapture.sampleFile('jpg');
    await tester.tap(find.byTooltip('Foto oder Video'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Foto aufnehmen'));
    await settleUntil(tester, labelled('Foto'));

    final n = (await notes(tester)).single;
    expect(n.type, NoteType.photo);
    expect(n.mediaPath, endsWith('.jpg'));
    expect(await stored(tester, n.mediaPath!), isTrue);
    expect(labelled('Foto'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('screenshot and video from the gallery', (tester) async {
    await openTask(tester);
    capture.next = FakeMediaCapture.sampleFile('png');
    await tester.tap(find.byTooltip('Screenshot anhängen'));
    await settleUntil(tester, labelled('Screenshot'));

    capture.next = FakeMediaCapture.sampleFile('mp4');
    await tester.tap(find.byTooltip('Foto oder Video'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Video auswählen'));
    await settleUntil(tester, find.text('Video'));

    final types = (await notes(tester)).map((n) => n.type).toSet();
    expect(types, {NoteType.screenshot, NoteType.video});
    await closeTestApp(tester, db);
  });

  testWidgets('no camera option where the device has none', (tester) async {
    capture = FakeMediaCapture(camera: false);
    await openTask(tester);
    await tester.tap(find.byTooltip('Foto oder Video'));
    await tester.pumpAndSettle();
    expect(find.text('Foto aufnehmen'), findsNothing);
    expect(find.text('Foto auswählen'), findsOneWidget);
    await closeTestApp(tester, db);
  });

  testWidgets('voice note: explained once, recorded, saved', (tester) async {
    await openTask(tester);
    await tester.tap(find.byTooltip('Sprachnotiz aufnehmen'));
    await settleAsync(tester);
    expect(find.text('Mikrofon verwenden?'), findsOneWidget);
    expect(capture.permissionRequests, 0);
    await tester.tap(find.text('Weiter'));
    await settleUntil(tester, find.text('Fertig'));
    expect(capture.permissionRequests, 1);
    expect(find.textContaining('Aufnahme läuft'), findsOneWidget);

    await tester.tap(find.text('Fertig'));
    await settleUntil(tester, find.textContaining('Sprachnotiz ·'));
    final n = (await notes(tester)).single;
    expect(n.type, NoteType.voice);
    expect(n.body, '0:00');
    expect(await stored(tester, n.mediaPath!), isTrue);
    expect(
      find.text('Abschrift folgt mit der Server-Anbindung'),
      findsOneWidget,
    );

    // Second time: no explanation again.
    await tester.tap(find.byTooltip('Sprachnotiz aufnehmen'));
    await settleUntil(tester, find.text('Verwerfen'));
    expect(find.text('Mikrofon verwenden?'), findsNothing);
    await tester.tap(find.text('Verwerfen'));
    await settleAsync(tester);
    expect(await notes(tester), hasLength(1));

    await closeTestApp(tester, db);
  });

  testWidgets('denied microphone shows a hint and records nothing', (
    tester,
  ) async {
    capture.micGranted = false;
    await openTask(tester);
    await tester.tap(find.byTooltip('Sprachnotiz aufnehmen'));
    await settleAsync(tester);
    await tester.tap(find.text('Weiter'));
    await settleUntil(tester, find.textContaining('Keine Erlaubnis'));
    expect(find.textContaining('Keine Erlaubnis'), findsOneWidget);
    expect(find.text('Fertig'), findsNothing);
    await closeTestApp(tester, db);
  });

  test('media store rejects unsafe names and round-trips backups', () async {
    final s = tempMediaStore();
    expect(MediaStore.isValidName('../secret.txt'), isFalse);
    expect(MediaStore.isValidName('a/b.jpg'), isFalse);
    expect(MediaStore.isValidName('0f3c-12.jpg'), isTrue);
    expect(
      () => MediaStore.decodeAll({
        '../x.jpg': base64Encode([1]),
      }),
      throwsFormatException,
    );

    final picked = FakeMediaCapture.sampleFile('jpg', [7, 8, 9]);
    final name = await s.import(picked.path, extension: 'JPG');
    expect(name, endsWith('.jpg'));
    final backup = await s.exportAll();

    final other = tempMediaStore();
    await (await other.file('alt-1.png')).writeAsBytes([1]);
    await other.replaceAll(MediaStore.decodeAll(backup));
    expect(await (await other.file(name)).readAsBytes(), [7, 8, 9]);
    expect(await (await other.file('alt-1.png')).exists(), isFalse);
    expect(File(picked.path).existsSync(), isTrue);
  });
}
