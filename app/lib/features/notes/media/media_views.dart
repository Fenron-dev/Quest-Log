import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../core/database/app_database.dart';
import '../../time/engine/time_math.dart' show formatHms;
import 'media_store.dart';

String formatClip(Duration d) {
  final s = d.inSeconds;
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}

/// Content of a non-text note: image, video or voice.
class MediaNoteContent extends ConsumerWidget {
  const MediaNoteContent({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dir = ref.watch(mediaDirProvider).value;
    final name = note.mediaPath;
    if (dir == null || name == null || !MediaStore.isValidName(name)) {
      return const SizedBox(height: 48);
    }
    final file = File('${dir.path}${Platform.pathSeparator}$name');
    return switch (note.type) {
      NoteType.photo || NoteType.screenshot => _ImageNote(
        file: file,
        label: note.type == NoteType.screenshot ? 'Screenshot' : 'Foto',
      ),
      NoteType.video => _VideoTile(file: file),
      NoteType.voice => VoiceNotePlayer(file: file, note: note),
      _ => Text(note.body ?? ''),
    };
  }
}

class _ImageNote extends StatelessWidget {
  const _ImageNote({required this.file, required this.label});

  final File file;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => _ImageViewer(file: file, title: label),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            cacheWidth: 800,
            errorBuilder: (_, _, _) => const _Missing(),
          ),
        ),
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.file, required this.title});

  final File file;
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text(title),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    body: InteractiveViewer(
      maxScale: 6,
      child: Center(
        child: Image.file(file, errorBuilder: (_, _, _) => const _Missing()),
      ),
    ),
  );
}

class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    alignment: Alignment.center,
    color: Theme.of(context).colorScheme.surfaceContainer,
    child: const Text('Datei nicht gefunden'),
  );
}

class _VideoTile extends StatelessWidget {
  const _VideoTile({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => _VideoPage(file: file))),
        child: const SizedBox(
          height: 120,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 48,
                  semanticLabel: 'Video abspielen',
                ),
                Text('Video', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoPage extends StatefulWidget {
  const _VideoPage({required this.file});

  final File file;

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  VideoPlayerController? _c;
  String? _error;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    try {
      final c = VideoPlayerController.file(widget.file);
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      c.addListener(() => mounted ? setState(() {}) : null);
      setState(() => _c = c);
      await c.play();
    } catch (_) {
      // No video backend on some desktop platforms.
      if (mounted) {
        setState(
          () =>
              _error = 'Video kann auf diesem System nicht abgespielt werden.',
        );
      }
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Video'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _error != null
            ? Text(_error!, style: const TextStyle(color: Colors.white))
            : c == null
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: c.value.aspectRatio,
                child: VideoPlayer(c),
              ),
      ),
      floatingActionButton: c == null
          ? null
          : FloatingActionButton(
              tooltip: c.value.isPlaying ? 'Pause' : 'Abspielen',
              onPressed: () => c.value.isPlaying ? c.pause() : c.play(),
              child: Icon(c.value.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
    );
  }
}

/// Play/pause for a voice note. Playback uses video_player (audio-only
/// files work there too); the player is created on first play.
class VoiceNotePlayer extends StatefulWidget {
  const VoiceNotePlayer({super.key, required this.file, required this.note});

  final File file;
  final Note note;

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  VideoPlayerController? _player;
  bool _playing = false;
  Duration _position = Duration.zero;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  void _onUpdate() {
    final v = _player?.value;
    if (v == null || !mounted) return;
    final finished =
        v.duration > Duration.zero && v.position >= v.duration && !v.isPlaying;
    setState(() {
      _playing = v.isPlaying;
      _position = finished ? Duration.zero : v.position;
    });
    if (finished) _player?.seekTo(Duration.zero);
  }

  Future<void> _toggle() async {
    try {
      var p = _player;
      if (p == null) {
        p = VideoPlayerController.file(widget.file);
        await p.initialize();
        p.addListener(_onUpdate);
        _player = p;
      }
      if (p.value.isPlaying) {
        await p.pause();
      } else {
        await p.play();
      }
    } catch (_) {
      // No playback backend on some desktop platforms.
      if (mounted) {
        setState(() => _playing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sprachnotiz kann auf diesem System nicht abgespielt werden.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final transcript = widget.note.transcript;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              tooltip: _playing ? 'Pause' : 'Sprachnotiz abspielen',
              icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
              onPressed: _toggle,
            ),
            const SizedBox(width: 8),
            Text(
              _playing || _position > Duration.zero
                  ? '${formatClip(_position)} / ${widget.note.body ?? ''}'
                  : 'Sprachnotiz · ${widget.note.body ?? ''}',
            ),
          ],
        ),
        if (transcript != null && transcript.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(transcript),
          )
        else
          Text(
            'Abschrift folgt mit der Server-Anbindung',
            style: textTheme.bodySmall,
          ),
      ],
    );
  }
}

/// Used by the recording bar.
String recordingLabel(Duration d) => 'Aufnahme läuft · ${formatHms(d)}';
