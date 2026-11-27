import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_crypto.dart';
import '../../core/backup/export.dart';
import '../../core/backup/snapshot.dart';
import '../../core/database/database_provider.dart';
import '../../core/settings/time_settings.dart';
import '../../core/settings/view_settings.dart';
import '../../core/theme/theme_settings.dart';
import '../../core/ui/formatting.dart';
import '../reminders/reminder_settings.dart';
import '../time/gap_fill_sheet.dart' show formatTime;
import 'backup_files.dart';

String _stamp(DateTime t) =>
    '${t.year}-${t.month.toString().padLeft(2, '0')}-'
    '${t.day.toString().padLeft(2, '0')}';

/// "Sichern und Export" in the settings: encrypted backup, restore and
/// unencrypted exports. Files only go where the user saves them.
class DataSection extends ConsumerWidget {
  const DataSection({super.key});

  void _snack(BuildContext context, String text) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  /// Shows a modal spinner while [work] runs.
  Future<T> _busy<T>(
    BuildContext context,
    String label,
    Future<T> Function() work,
  ) async {
    final nav = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(child: Text(label)),
            ],
          ),
        ),
      ),
    );
    try {
      return await work();
    } finally {
      nav.pop();
    }
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    final password = await showDialog<String>(
      context: context,
      builder: (_) => const _PasswordDialog(confirm: true),
    );
    if (password == null || !context.mounted) return;
    final db = ref.read(databaseProvider);
    final kdf = ref.read(backupKdfProvider);
    final run = ref.read(backgroundRunnerProvider);
    final Uint8List bytes;
    try {
      bytes = await _busy(context, 'Sicherung wird verschlüsselt …', () async {
        final snap = await dumpDatabase(db);
        return run(() => encryptBackup(snap, password, kdf: kdf));
      });
    } on BackupException catch (e) {
      if (context.mounted) _snack(context, e.message);
      return;
    }
    final saved = await ref
        .read(backupFilesProvider)
        .save(
          'quest-log-${_stamp(DateTime.now())}.$backupExtension',
          bytes,
          'application/octet-stream',
        );
    if (saved && context.mounted) {
      _snack(context, 'Sicherung gespeichert.');
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final file = await ref.read(backupFilesProvider).open();
    if (file == null || !context.mounted) return;
    final password = await showDialog<String>(
      context: context,
      builder: (_) => const _PasswordDialog(confirm: false),
    );
    if (password == null || !context.mounted) return;
    final db = ref.read(databaseProvider);
    final run = ref.read(backgroundRunnerProvider);
    final Object? snap;
    final SnapshotInfo info;
    try {
      snap = await _busy(
        context,
        'Sicherung wird entschlüsselt …',
        () => run(() => decryptBackup(file, password)),
      );
      info = inspectSnapshot(db, snap);
    } on BackupException catch (e) {
      if (context.mounted) _snack(context, e.message);
      return;
    }
    if (!context.mounted) return;
    final when = info.createdAt;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Sicherung wiederherstellen?'),
        content: Text(
          '${when == null ? '' : 'Stand ${formatDate(when)}, '
                    '${formatTime(when)} Uhr\n'}'
          '${info.count('customers')} Kunden · '
          '${info.count('projects')} Projekte · '
          '${info.count('tasks')} Aufgaben · '
          '${info.count('time_entries')} Zeiteinträge\n\n'
          'Alle Daten auf diesem Gerät werden dadurch ersetzt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Ersetzen'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await _busy(
        context,
        'Daten werden wiederhergestellt …',
        () => restoreDatabase(db, snap),
      );
    } catch (_) {
      if (context.mounted) {
        _snack(
          context,
          'Wiederherstellen fehlgeschlagen. Die Daten sind unverändert.',
        );
      }
      return;
    }
    // Preferences are cached in notifiers; reload them from the database.
    ref
      ..invalidate(themeSettingsProvider)
      ..invalidate(timeSettingsProvider)
      ..invalidate(reminderSettingsProvider)
      ..invalidate(nowViewProvider)
      ..invalidate(jetztViewProvider)
      ..invalidate(dayViewProvider);
    if (context.mounted) _snack(context, 'Sicherung wiederhergestellt.');
  }

  Future<void> _export(
    BuildContext context,
    WidgetRef ref, {
    required bool csv,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Unverschlüsselt exportieren?'),
        content: const Text(
          'Der Export enthält Kunden- und Kontaktdaten im Klartext. '
          'Speichere ihn nur an einem sicheren Ort. Für eine Sicherung '
          'nutze „Jetzt sichern“.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Exportieren'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final db = ref.read(databaseProvider);
    final stamp = _stamp(DateTime.now());
    final saved = csv
        ? await ref
              .read(backupFilesProvider)
              .save(
                'quest-log-zeiten-$stamp.csv',
                await exportTimeEntriesCsv(db),
                'text/csv',
              )
        : await ref
              .read(backupFilesProvider)
              .save(
                'quest-log-export-$stamp.json',
                await exportJson(db),
                'application/json',
              );
    if (saved && context.mounted) _snack(context, 'Export gespeichert.');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sichern und Export', style: textTheme.titleMedium),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.lock_outline),
          title: const Text('Jetzt sichern'),
          subtitle: const Text('Verschlüsselte Datei mit deinem Passwort'),
          onTap: () => _backup(context, ref),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.settings_backup_restore),
          title: const Text('Wiederherstellen'),
          subtitle: const Text('Ersetzt alle Daten durch eine Sicherung'),
          onTap: () => _restore(context, ref),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.data_object),
          title: const Text('Export JSON'),
          subtitle: const Text('Alle Daten lesbar, unverschlüsselt'),
          onTap: () => _export(context, ref, csv: false),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.table_chart_outlined),
          title: const Text('Export CSV'),
          subtitle: const Text('Zeiteinträge für Tabellen, unverschlüsselt'),
          onTap: () => _export(context, ref, csv: true),
        ),
      ],
    );
  }
}

/// Asks for the backup password; with [confirm] it must be typed twice.
class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({required this.confirm});

  final bool confirm;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _first = TextEditingController();
  final _second = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void _submit() {
    final pw = _first.text;
    if (widget.confirm) {
      if (pw.length < minBackupPasswordLength) {
        setState(() => _error = 'Mindestens $minBackupPasswordLength Zeichen.');
        return;
      }
      if (pw != _second.text) {
        setState(() => _error = 'Die Passwörter stimmen nicht überein.');
        return;
      }
    } else if (pw.isEmpty) {
      return;
    }
    Navigator.pop(context, pw);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.confirm ? 'Sicherung verschlüsseln' : 'Passwort'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.confirm)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Ohne dieses Passwort lässt sich die Sicherung nicht '
                'wiederherstellen. Es wird nirgends gespeichert.',
              ),
            ),
          TextField(
            controller: _first,
            autofocus: true,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Passwort',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => widget.confirm ? null : _submit(),
          ),
          if (widget.confirm) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _second,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Passwort wiederholen',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.confirm ? 'Sichern' : 'Öffnen'),
        ),
      ],
    );
  }
}
