import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/database/tables/sync_columns.dart' show newUuid;

/// Media files of notes in the app's private storage. Notes only keep the
/// file name, so backups and devices stay portable.
class MediaStore {
  MediaStore(this._resolveDir);

  final Future<Directory> Function() _resolveDir;
  Future<Directory>? _dir;

  static final _validName = RegExp(r'^[A-Za-z0-9-]{1,64}\.[a-z0-9]{1,5}$');

  /// Only plain file names are accepted (no paths, no traversal).
  static bool isValidName(String name) => _validName.hasMatch(name);

  Future<Directory> dir() => _dir ??= () async {
    final d = await _resolveDir();
    await d.create(recursive: true);
    return d;
  }();

  Future<File> file(String name) async {
    if (!isValidName(name)) throw ArgumentError.value(name, 'name');
    return File('${(await dir()).path}${Platform.pathSeparator}$name');
  }

  /// Copies [sourcePath] into the store; returns the new file name.
  Future<String> import(String sourcePath, {required String extension}) async {
    final ext = extension.toLowerCase().replaceAll('.', '');
    final name = '${newUuid()}.${ext.isEmpty ? 'bin' : ext}';
    await File(sourcePath).copy((await file(name)).path);
    return name;
  }

  /// A fresh path inside the store for a recording.
  Future<(String name, String path)> reserve(String extension) async {
    final name = '${newUuid()}.$extension';
    return (name, (await file(name)).path);
  }

  Future<void> delete(String name) async {
    final f = await file(name);
    if (await f.exists()) await f.delete();
  }

  /// All media as base64, for backups.
  Future<Map<String, String>> exportAll() async {
    final out = <String, String>{};
    await for (final e in (await dir()).list()) {
      final name = e.uri.pathSegments.last;
      if (e is File && isValidName(name)) {
        out[name] = base64Encode(await e.readAsBytes());
      }
    }
    return out;
  }

  /// Validates and decodes media from a backup; throws [FormatException].
  static Map<String, List<int>> decodeAll(Map<String, Object?> files) {
    final decoded = <String, List<int>>{};
    for (final MapEntry(:key, :value) in files.entries) {
      if (!isValidName(key) || value is! String) {
        throw const FormatException('Invalid media entry');
      }
      decoded[key] = base64Decode(value);
    }
    return decoded;
  }

  /// Replaces all media with [files] (decoded with [decodeAll]).
  Future<void> replaceAll(Map<String, List<int>> files) async {
    await for (final e in (await dir()).list()) {
      if (e is File) await e.delete();
    }
    for (final MapEntry(:key, :value) in files.entries) {
      await (await file(key)).writeAsBytes(value, flush: true);
    }
  }
}

final mediaStoreProvider = Provider<MediaStore>(
  (_) => MediaStore(
    () async => Directory(
      '${(await getApplicationSupportDirectory()).path}'
      '${Platform.pathSeparator}media',
    ),
  ),
);

/// The resolved media directory, for synchronous file access in widgets.
final mediaDirProvider = FutureProvider<Directory>(
  (ref) => ref.watch(mediaStoreProvider).dir(),
);
