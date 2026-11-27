import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/formatting.dart';
import '../time/gap_fill_sheet.dart' show formatTime;
import 'data/notes_repository.dart';
import 'media/media_capture.dart';
import 'media/media_store.dart';
import 'media/media_views.dart';

/// Chronological notes (chat style): text, photos, videos, screenshots
/// and voice notes, with an input line for all of them.
class NotesSection extends ConsumerStatefulWidget {
  const NotesSection({super.key, required this.type, required this.parentId});

  final NoteParentType type;
  final String parentId;

  @override
  ConsumerState<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends ConsumerState<NotesSection> {
  static const _micExplainedKey = 'micExplained';

  final _input = TextEditingController();

  /// Running voice recording: file name in the store and elapsed time.
  String? _recording;
  final _elapsed = Stopwatch();
  Timer? _tick;

  @override
  void dispose() {
    _input.dispose();
    _tick?.cancel();
    if (_recording != null) {
      unawaited(ref.read(mediaCaptureProvider).cancelRecording());
    }
    super.dispose();
  }

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _saveMedia(PickedMedia? picked, NoteType type) async {
    if (picked == null) return;
    try {
      final name = await ref
          .read(mediaStoreProvider)
          .import(picked.path, extension: picked.extension);
      await ref
          .read(notesRepositoryProvider)
          .addMedia(widget.type, widget.parentId, type, name);
    } catch (_) {
      _snack('Die Datei konnte nicht gespeichert werden.');
    }
  }

  Future<void> _camera() async {
    final capture = ref.read(mediaCaptureProvider);
    final choice = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (capture.canUseCamera) ...[
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Foto aufnehmen'),
                onTap: () => Navigator.pop(sheet, 0),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: const Text('Video aufnehmen'),
                onTap: () => Navigator.pop(sheet, 1),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Foto auswählen'),
              onTap: () => Navigator.pop(sheet, 2),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Video auswählen'),
              onTap: () => Navigator.pop(sheet, 3),
            ),
          ],
        ),
      ),
    );
    switch (choice) {
      case 0:
        await _saveMedia(await capture.takePhoto(), NoteType.photo);
      case 1:
        await _saveMedia(await capture.recordVideo(), NoteType.video);
      case 2:
        await _saveMedia(await capture.pickImage(), NoteType.photo);
      case 3:
        await _saveMedia(await capture.pickVideo(), NoteType.video);
    }
  }

  Future<void> _screenshot() async => _saveMedia(
    await ref.read(mediaCaptureProvider).pickImage(),
    NoteType.screenshot,
  );

  Future<void> _startVoice() async {
    final db = ref.read(databaseProvider);
    if (await db.readSetting(_micExplainedKey) == null) {
      if (!mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text('Mikrofon verwenden?'),
          content: const Text(
            'Für Sprachnotizen braucht Quest-Log Zugriff auf das Mikrofon. '
            'Aufgenommen wird nur, solange die Aufnahme läuft; die Datei '
            'bleibt auf diesem Gerät.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('Weiter'),
            ),
          ],
        ),
      );
      if (ok != true) return;
      await db.writeSetting(_micExplainedKey, 'true');
    }
    final capture = ref.read(mediaCaptureProvider);
    if (!await capture.microphonePermission()) {
      _snack(
        'Keine Erlaubnis für das Mikrofon. Du kannst sie in den '
        'Systemeinstellungen der App erteilen.',
      );
      return;
    }
    final store = ref.read(mediaStoreProvider);
    final (name, path) = await store.reserve('m4a');
    try {
      await capture.startRecording(path);
    } catch (_) {
      _snack('Die Aufnahme konnte nicht gestartet werden.');
      return;
    }
    if (!mounted) return;
    setState(() => _recording = name);
    _elapsed
      ..reset()
      ..start();
    _tick = Timer.periodic(
      const Duration(seconds: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  Future<void> _finishVoice({required bool keep}) async {
    final name = _recording;
    if (name == null) return;
    _tick?.cancel();
    _elapsed.stop();
    setState(() => _recording = null);
    final capture = ref.read(mediaCaptureProvider);
    final store = ref.read(mediaStoreProvider);
    if (!keep) {
      await capture.cancelRecording();
      await store.delete(name);
      return;
    }
    final path = await capture.stopRecording();
    if (path == null) {
      await store.delete(name);
      _snack('Die Aufnahme ist leer.');
      return;
    }
    await ref
        .read(notesRepositoryProvider)
        .addMedia(
          widget.type,
          widget.parentId,
          NoteType.voice,
          name,
          body: formatClip(_elapsed.elapsed),
        );
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    await ref
        .read(notesRepositoryProvider)
        .addText(widget.type, widget.parentId, text);
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    final notes =
        ref
            .watch(
              notesProvider((type: widget.type, parentId: widget.parentId)),
            )
            .value ??
        const <Note>[];
    final scheme = Theme.of(context).colorScheme;
    final repo = ref.read(notesRepositoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Notizen'),
        if (notes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text('Noch keine Notizen'),
          ),
        for (final n in notes)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: GestureDetector(
              onLongPress: () => _noteActions(context, n, repo),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: n.isSolution
                      ? scheme.primaryContainer
                      : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (n.type == NoteType.text)
                      Text(n.body ?? '')
                    else
                      MediaNoteContent(note: n),
                    const SizedBox(height: 4),
                    Text(
                      '${formatDate(n.createdAt)} ${formatTime(n.createdAt)}'
                      '${n.isSolution ? ' · Lösung' : ''}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_recording != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Row(
              children: [
                Icon(Icons.fiber_manual_record, color: scheme.error),
                const SizedBox(width: 8),
                Expanded(child: Text(recordingLabel(_elapsed.elapsed))),
                TextButton(
                  onPressed: () => _finishVoice(keep: false),
                  child: const Text('Verwerfen'),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.stop),
                  label: const Text('Fertig'),
                  onPressed: () => _finishVoice(keep: true),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Sprachnotiz aufnehmen',
                  icon: const Icon(Icons.mic_none),
                  onPressed: _startVoice,
                ),
                IconButton(
                  tooltip: 'Foto oder Video',
                  icon: const Icon(Icons.photo_camera_outlined),
                  onPressed: _camera,
                ),
                IconButton(
                  tooltip: 'Screenshot anhängen',
                  icon: const Icon(Icons.screenshot_monitor_outlined),
                  onPressed: _screenshot,
                ),
                Expanded(
                  child: TextField(
                    controller: _input,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Notiz schreiben',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Notiz speichern',
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _noteActions(
    BuildContext context,
    Note note,
    NotesRepository repo,
  ) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: Text(
              note.isSolution
                  ? 'Nicht mehr als Lösung markieren'
                  : 'Als Lösung markieren',
            ),
            onTap: () {
              Navigator.pop(sheet);
              repo.setSolution(note.id, !note.isSolution);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Notiz löschen'),
            onTap: () {
              Navigator.pop(sheet);
              repo.delete(note.id);
            },
          ),
        ],
      ),
    ),
  );
}
