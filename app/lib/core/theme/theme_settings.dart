import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_provider.dart';
import 'app_theme.dart';

class ThemeSettings {
  const ThemeSettings({
    this.theme = ThemeChoice.light,
    this.accent = AccentChoice.blue,
  });

  final ThemeChoice theme;
  final AccentChoice accent;

  ThemeSettings copyWith({ThemeChoice? theme, AccentChoice? accent}) =>
      ThemeSettings(theme: theme ?? this.theme, accent: accent ?? this.accent);
}

const _themeKey = 'theme';
const _accentKey = 'accent';

T _byName<T extends Enum>(List<T> values, String? name, T fallback) =>
    values.firstWhere((v) => v.name == name, orElse: () => fallback);

class ThemeSettingsNotifier extends AsyncNotifier<ThemeSettings> {
  @override
  Future<ThemeSettings> build() async {
    final db = ref.watch(databaseProvider);
    const defaults = ThemeSettings();
    return ThemeSettings(
      theme: _byName(
        ThemeChoice.values,
        await db.readSetting(_themeKey),
        defaults.theme,
      ),
      accent: _byName(
        AccentChoice.values,
        await db.readSetting(_accentKey),
        defaults.accent,
      ),
    );
  }

  Future<void> setTheme(ThemeChoice theme) async {
    final current = state.value ?? const ThemeSettings();
    state = AsyncData(current.copyWith(theme: theme));
    await ref.read(databaseProvider).writeSetting(_themeKey, theme.name);
  }

  Future<void> setAccent(AccentChoice accent) async {
    final current = state.value ?? const ThemeSettings();
    state = AsyncData(current.copyWith(accent: accent));
    await ref.read(databaseProvider).writeSetting(_accentKey, accent.name);
  }
}

final themeSettingsProvider =
    AsyncNotifierProvider<ThemeSettingsNotifier, ThemeSettings>(
      ThemeSettingsNotifier.new,
    );
