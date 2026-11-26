import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/formatting.dart';
import '../time/gap_fill_sheet.dart' show formatTime;
import 'data/notes_repository.dart';

/// Chronological text notes (chat style) with an input line.
class NotesSection extends ConsumerStatefulWidget {
  const NotesSection({super.key, required this.type, required this.parentId});

  final NoteParentType type;
  final String parentId;

  @override
  ConsumerState<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends ConsumerState<NotesSection> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
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
                    Text(n.body ?? ''),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
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
