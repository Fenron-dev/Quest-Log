import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_service.dart';
import 'reminder_settings.dart';

String _clock(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutes % 60).toString().padLeft(2, '0')}';

/// "Erinnerungen" in the settings. Switching on explains the purpose and
/// only then asks for the notification permission.
class ReminderSettingsSection extends ConsumerWidget {
  const ReminderSettingsSection({super.key});

  Future<void> _enable(
    BuildContext context,
    WidgetRef ref,
    ReminderSettings s,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Erinnerungen erlauben?'),
        content: const Text(
          'Quest-Log erinnert dich an Termine, Nachfass-Termine, lange '
          'laufende Timer sowie an Tages- und Wochenabschluss. Dafür '
          'braucht die App die Erlaubnis für Benachrichtigungen. Die '
          'Erinnerungen werden nur auf diesem Gerät geplant.',
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
    final granted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    if (!granted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Keine Erlaubnis für Benachrichtigungen. Du kannst sie in den '
              'Systemeinstellungen der App erteilen.',
            ),
          ),
        );
      }
      return;
    }
    await ref
        .read(reminderSettingsProvider.notifier)
        .save(s.copyWith(enabled: true));
  }

  Future<void> _pickEndOfDay(
    BuildContext context,
    WidgetRef ref,
    ReminderSettings s,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: s.endOfDayMin ~/ 60,
        minute: s.endOfDayMin % 60,
      ),
    );
    if (picked == null) return;
    await ref
        .read(reminderSettingsProvider.notifier)
        .save(s.copyWith(endOfDayMin: picked.hour * 60 + picked.minute));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(reminderSettingsProvider).value;
    final textTheme = Theme.of(context).textTheme;
    if (s == null) return const SizedBox.shrink();
    final notifier = ref.read(reminderSettingsProvider.notifier);
    void save(ReminderSettings next) => notifier.save(next);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Erinnerungen', style: textTheme.titleMedium),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Erinnerungen'),
          subtitle: Text(
            s.enabled ? 'Benachrichtigungen auf diesem Gerät' : 'Aus',
          ),
          value: s.enabled,
          onChanged: (v) =>
              v ? _enable(context, ref, s) : save(s.copyWith(enabled: false)),
        ),
        if (s.enabled) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Feierabend um'),
            subtitle: const Text('Für Timer-Schutz und Tagesabschluss'),
            trailing: TextButton(
              onPressed: () => _pickEndOfDay(context, ref, s),
              child: Text(_clock(s.endOfDayMin)),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Termine'),
            value: s.appointments,
            onChanged: (v) => save(s.copyWith(appointments: v)),
          ),
          if (s.appointments)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              title: const Text('Vorlauf'),
              trailing: DropdownButton<int>(
                value: s.appointmentLeadMin,
                items: [
                  for (final m in {0, 5, 10, 15, 30, 60, s.appointmentLeadMin})
                    DropdownMenuItem(
                      value: m,
                      child: Text(m == 0 ? 'zur Startzeit' : '$m min vorher'),
                    ),
                ],
                onChanged: (v) =>
                    v == null ? null : save(s.copyWith(appointmentLeadMin: v)),
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Nachfassen'),
            subtitle: Text(
              'Am Nachfass-Tag um ${_clock(s.followUpHour * 60)} Uhr',
            ),
            value: s.followUps,
            onChanged: (v) => save(s.copyWith(followUps: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Timer-Schutz'),
            subtitle: const Text(
              'Nachfrage, wenn ein Timer lange oder nach Feierabend läuft',
            ),
            value: s.timerGuard,
            onChanged: (v) => save(s.copyWith(timerGuard: v)),
          ),
          if (s.timerGuard)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              title: const Text('Nachfragen nach'),
              trailing: DropdownButton<int>(
                value: s.timerGuardMin,
                items: [
                  for (final m in {60, 90, 120, 180, 240, s.timerGuardMin})
                    DropdownMenuItem(
                      value: m,
                      child: Text(
                        m % 60 == 0
                            ? '${m ~/ 60} h'
                            : '${m / 60} h'.replaceAll('.', ','),
                      ),
                    ),
                ],
                onChanged: (v) =>
                    v == null ? null : save(s.copyWith(timerGuardMin: v)),
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Morgenplanung'),
            subtitle: Text('Mo–Fr um ${_clock(s.morningMin)} Uhr'),
            value: s.morningPlan,
            onChanged: (v) => save(s.copyWith(morningPlan: v)),
          ),
          if (s.morningPlan)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              title: const Text('Uhrzeit'),
              trailing: TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: s.morningMin ~/ 60,
                      minute: s.morningMin % 60,
                    ),
                  );
                  if (picked != null) {
                    save(
                      s.copyWith(morningMin: picked.hour * 60 + picked.minute),
                    );
                  }
                },
                child: Text(_clock(s.morningMin)),
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tagesabschluss'),
            subtitle: const Text('Mo–Do zum Feierabend'),
            value: s.dayClose,
            onChanged: (v) => save(s.copyWith(dayClose: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Wochenabschluss'),
            subtitle: const Text('Freitags zum Feierabend'),
            value: s.weekClose,
            onChanged: (v) => save(s.copyWith(weekClose: v)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Test-Benachrichtigung'),
              onPressed: () => ref
                  .read(notificationServiceProvider)
                  .showNow(
                    'Quest-Log',
                    'So sehen Erinnerungen auf diesem Gerät aus.',
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
