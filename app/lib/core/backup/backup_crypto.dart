import 'dart:convert';
import 'dart:io' show gzip;
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'snapshot.dart';

/// File format of encrypted backups: a small JSON envelope with the key
/// derivation parameters and the AES-256-GCM encrypted, gzipped snapshot.
const backupFormat = 'quest-log-backup';
const backupVersion = 1;
const backupExtension = 'qlbackup';

/// Minimum password length for backups.
const minBackupPasswordLength = 8;

/// Argon2id parameters stored with each backup.
class KdfParams {
  const KdfParams({
    required this.memoryKib,
    required this.iterations,
    required this.parallelism,
  });

  /// OWASP recommendation for Argon2id (19 MiB, 2 passes).
  static const standard = KdfParams(
    memoryKib: 19456,
    iterations: 2,
    parallelism: 1,
  );

  final int memoryKib;
  final int iterations;
  final int parallelism;
}

final _aad = utf8.encode('$backupFormat/$backupVersion');

Future<SecretKey> _deriveKey(String password, List<int> salt, KdfParams p) =>
    Argon2id(
      parallelism: p.parallelism,
      memory: p.memoryKib,
      iterations: p.iterations,
      hashLength: 32,
    ).deriveKeyFromPassword(password: password, nonce: salt);

List<int> _random(int n) {
  final r = Random.secure();
  return List<int>.generate(n, (_) => r.nextInt(256));
}

/// Encrypts a snapshot (as produced by `dumpDatabase`) with [password].
Future<Uint8List> encryptBackup(
  Map<String, Object?> snapshot,
  String password, {
  KdfParams kdf = KdfParams.standard,
}) async {
  if (password.length < minBackupPasswordLength) {
    throw const BackupException('Das Passwort ist zu kurz.');
  }
  final salt = _random(16);
  final key = await _deriveKey(password, salt, kdf);
  final plain = gzip.encode(utf8.encode(jsonEncode(snapshot)));
  final box = await AesGcm.with256bits().encrypt(
    plain,
    secretKey: key,
    aad: _aad,
  );
  final envelope = {
    'format': backupFormat,
    'version': backupVersion,
    'kdf': {
      'name': 'argon2id',
      'memoryKib': kdf.memoryKib,
      'iterations': kdf.iterations,
      'parallelism': kdf.parallelism,
      'salt': base64Encode(salt),
    },
    'cipher': {'name': 'aes-256-gcm', 'nonce': base64Encode(box.nonce)},
    'data': base64Encode([...box.cipherText, ...box.mac.bytes]),
  };
  return Uint8List.fromList(utf8.encode(jsonEncode(envelope)));
}

/// Decrypts a backup file; returns the snapshot JSON.
///
/// Throws [BackupException] for foreign files, a wrong password or
/// tampered data.
Future<Object?> decryptBackup(List<int> file, String password) async {
  final Map<String, Object?> env;
  try {
    final decoded = jsonDecode(utf8.decode(file));
    if (decoded is! Map<String, Object?>) throw const FormatException();
    env = decoded;
  } on FormatException {
    throw const BackupException('Keine Quest-Log-Sicherung.');
  }
  if (env['format'] != backupFormat) {
    throw const BackupException('Keine Quest-Log-Sicherung.');
  }
  if (env['version'] != backupVersion) {
    throw const BackupException(
      'Dieses Sicherungsformat kennt die App nicht. Bitte die App '
      'aktualisieren.',
    );
  }
  try {
    final kdf = env['kdf']! as Map<String, Object?>;
    final cipher = env['cipher']! as Map<String, Object?>;
    if (kdf['name'] != 'argon2id' || cipher['name'] != 'aes-256-gcm') {
      throw const FormatException();
    }
    // Bounds keep a crafted file from demanding absurd resources.
    final params = KdfParams(
      memoryKib: _bounded(kdf['memoryKib'], 8, 256 * 1024),
      iterations: _bounded(kdf['iterations'], 1, 10),
      parallelism: _bounded(kdf['parallelism'], 1, 8),
    );
    final salt = base64Decode(kdf['salt']! as String);
    final nonce = base64Decode(cipher['nonce']! as String);
    final data = base64Decode(env['data']! as String);
    if (data.length < 16 || nonce.length != 12) throw const FormatException();
    final box = SecretBox(
      data.sublist(0, data.length - 16),
      nonce: nonce,
      mac: Mac(data.sublist(data.length - 16)),
    );
    final key = await _deriveKey(password, salt, params);
    final List<int> plain;
    try {
      plain = await AesGcm.with256bits().decrypt(
        box,
        secretKey: key,
        aad: _aad,
      );
    } on SecretBoxAuthenticationError {
      throw const BackupException(
        'Falsches Passwort oder beschädigte Sicherung.',
      );
    }
    return jsonDecode(utf8.decode(gzip.decode(plain)));
  } on BackupException {
    rethrow;
  } catch (_) {
    throw const BackupException('Die Sicherung ist beschädigt.');
  }
}

int _bounded(Object? v, int min, int max) {
  if (v is! int || v < min || v > max) throw const FormatException();
  return v;
}
