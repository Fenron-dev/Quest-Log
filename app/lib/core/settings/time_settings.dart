import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_provider.dart';

class TimeSettings {
  const TimeSettings({
    this.aeMinutes = 10,
    this.backgroundWeightPercent = 50,
    this.pauseOthers = true,
    this.quickStartEnabled = true,
  });

  /// Length of one work unit (AE) in minutes.
  final int aeMinutes;

  /// Weight of background timers when time overlaps, in percent.
  final int backgroundWeightPercent;

  /// Default for "pause other timers" when starting a timer.
  final bool pauseOthers;

  /// Whether the quick-start bar is shown on Jetzt.
  final bool quickStartEnabled;

  double get backgroundWeight => backgroundWeightPercent / 100;

  TimeSettings copyWith({
    int? aeMinutes,
    int? backgroundWeightPercent,
    bool? pauseOthers,
    bool? quickStartEnabled,
  }) => TimeSettings(
    aeMinutes: aeMinutes ?? this.aeMinutes,
    backgroundWeightPercent:
        backgroundWeightPercent ?? this.backgroundWeightPercent,
    pauseOthers: pauseOthers ?? this.pauseOthers,
    quickStartEnabled: quickStartEnabled ?? this.quickStartEnabled,
  );
}

const _aeKey = 'aeMinutes';
const _weightKey = 'backgroundWeightPercent';
const _pauseKey = 'pauseOthers';
const _quickKey = 'quickStartEnabled';

class TimeSettingsNotifier extends AsyncNotifier<TimeSettings> {
  @override
  Future<TimeSettings> build() async {
    final db = ref.watch(databaseProvider);
    const d = TimeSettings();
    int intOr(String? v, int fallback) => int.tryParse(v ?? '') ?? fallback;
    bool boolOr(String? v, bool fallback) => v == null ? fallback : v == 'true';
    return TimeSettings(
      aeMinutes: intOr(await db.readSetting(_aeKey), d.aeMinutes).clamp(1, 60),
      backgroundWeightPercent: intOr(
        await db.readSetting(_weightKey),
        d.backgroundWeightPercent,
      ).clamp(0, 100),
      pauseOthers: boolOr(await db.readSetting(_pauseKey), d.pauseOthers),
      quickStartEnabled: boolOr(
        await db.readSetting(_quickKey),
        d.quickStartEnabled,
      ),
    );
  }

  Future<void> save(TimeSettings next) async {
    state = AsyncData(next);
    final db = ref.read(databaseProvider);
    await db.writeSetting(_aeKey, '${next.aeMinutes}');
    await db.writeSetting(_weightKey, '${next.backgroundWeightPercent}');
    await db.writeSetting(_pauseKey, '${next.pauseOthers}');
    await db.writeSetting(_quickKey, '${next.quickStartEnabled}');
  }
}

final timeSettingsProvider =
    AsyncNotifierProvider<TimeSettingsNotifier, TimeSettings>(
      TimeSettingsNotifier.new,
    );

/// Current settings or defaults while loading.
final currentTimeSettingsProvider = Provider<TimeSettings>(
  (ref) => ref.watch(timeSettingsProvider).value ?? const TimeSettings(),
);
