import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_crypto.dart';

/// Saving and opening files through the system dialogs. Nothing is ever
/// uploaded; the user picks the location.
abstract class BackupFiles {
  /// Returns false if the user cancelled.
  Future<bool> save(String fileName, Uint8List bytes, String mimeType);

  /// Returns null if the user cancelled.
  Future<Uint8List?> open();
}

class PickerBackupFiles implements BackupFiles {
  const PickerBackupFiles();

  @override
  Future<bool> save(String fileName, Uint8List bytes, String mimeType) async =>
      await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: mimeType,
      ) !=
      null;

  @override
  Future<Uint8List?> open() async {
    final file = await FilePicker.pickFile(dialogTitle: 'Sicherung öffnen');
    return file?.readAsBytes();
  }
}

final backupFilesProvider = Provider<BackupFiles>(
  (_) => const PickerBackupFiles(),
);

/// Key derivation parameters for new backups (lowered in tests).
final backupKdfProvider = Provider<KdfParams>((_) => KdfParams.standard);

typedef BackgroundRunner = Future<R> Function<R>(FutureOr<R> Function() task);

/// Runs CPU-heavy work (key derivation) off the UI isolate.
final backgroundRunnerProvider = Provider<BackgroundRunner>(
  (_) =>
      <R>(task) => Isolate.run(task),
);
