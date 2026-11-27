import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';

/// Local reminder preferences. Everything is off until the user enables
/// reminders (and grants the notification permission).
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.appointments = true,
    this.appointmentLeadMin = 10,
    this.followUps = true,
    this.followUpHour = 8,
    this.timerGuard = true,
    this.timerGuardMin = 120,
    this.endOfDayMin = 17 * 60,
    this.dayClose = true,
    this.weekClose = true,
  });

  final bool enabled;
  final bool appointments;

  /// Minutes before an appointment.
  final int appointmentLeadMin;
  final bool followUps;

  /// Hour of the day on which follow-ups are announced.
  final int followUpHour;

  /// Ask when a timer runs long or past the end of the working day.
  final bool timerGuard;
  final int timerGuardMin;

  /// End of the working day, minutes after midnight.
  final int endOfDayMin;

  /// Reminder to close the day (Mon–Thu) or the week (Friday).
  final bool dayClose;
  final bool weekClose;

  ReminderSettings copyWith({
    bool? enabled,
    bool? appointments,
    int? appointmentLeadMin,
    bool? followUps,
    int? followUpHour,
    bool? timerGuard,
    int? timerGuardMin,
    int? endOfDayMin,
    bool? dayClose,
    bool? weekClose,
  }) => ReminderSettings(
    enabled: enabled ?? this.enabled,
    appointments: appointments ?? this.appointments,
    appointmentLeadMin: appointmentLeadMin ?? this.appointmentLeadMin,
    followUps: followUps ?? this.followUps,
    followUpHour: followUpHour ?? this.followUpHour,
    timerGuard: timerGuard ?? this.timerGuard,
    timerGuardMin: timerGuardMin ?? this.timerGuardMin,
    endOfDayMin: endOfDayMin ?? this.endOfDayMin,
    dayClose: dayClose ?? this.dayClose,
    weekClose: weekClose ?? this.weekClose,
  );

  Map<String, Object> toJson() => {
    'enabled': enabled,
    'appointments': appointments,
    'appointmentLeadMin': appointmentLeadMin,
    'followUps': followUps,
    'followUpHour': followUpHour,
    'timerGuard': timerGuard,
    'timerGuardMin': timerGuardMin,
    'endOfDayMin': endOfDayMin,
    'dayClose': dayClose,
    'weekClose': weekClose,
  };

  factory ReminderSettings.fromJson(Map<String, Object?> j) {
    const d = ReminderSettings();
    bool b(String k, bool f) => j[k] is bool ? j[k]! as bool : f;
    int i(String k, int f, int min, int max) =>
        j[k] is int ? (j[k]! as int).clamp(min, max) : f;
    return ReminderSettings(
      enabled: b('enabled', d.enabled),
      appointments: b('appointments', d.appointments),
      appointmentLeadMin: i('appointmentLeadMin', d.appointmentLeadMin, 0, 240),
      followUps: b('followUps', d.followUps),
      followUpHour: i('followUpHour', d.followUpHour, 0, 23),
      timerGuard: b('timerGuard', d.timerGuard),
      timerGuardMin: i('timerGuardMin', d.timerGuardMin, 15, 600),
      endOfDayMin: i('endOfDayMin', d.endOfDayMin, 0, 24 * 60 - 1),
      dayClose: b('dayClose', d.dayClose),
      weekClose: b('weekClose', d.weekClose),
    );
  }
}

const _key = 'reminders';

class ReminderSettingsNotifier extends AsyncNotifier<ReminderSettings> {
  @override
  Future<ReminderSettings> build() async {
    final raw = await ref.watch(databaseProvider).readSetting(_key);
    if (raw == null) return const ReminderSettings();
    try {
      final json = jsonDecode(raw);
      if (json is Map<String, Object?>) return ReminderSettings.fromJson(json);
    } on FormatException {
      // Fall through to defaults.
    }
    return const ReminderSettings();
  }

  Future<void> save(ReminderSettings next) async {
    state = AsyncData(next);
    await ref
        .read(databaseProvider)
        .writeSetting(_key, jsonEncode(next.toJson()));
  }
}

final reminderSettingsProvider =
    AsyncNotifierProvider<ReminderSettingsNotifier, ReminderSettings>(
      ReminderSettingsNotifier.new,
    );
