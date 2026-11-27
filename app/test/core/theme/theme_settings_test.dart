import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/database_provider.dart';
import 'package:quest_log/core/theme/app_theme.dart';
import 'package:quest_log/core/theme/theme_settings.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('defaults to light theme with blue accent', () async {
    final settings = await container().read(themeSettingsProvider.future);
    expect(settings.theme, ThemeChoice.light);
    expect(settings.accent, AccentChoice.blue);
  });

  test('persists choices across containers', () async {
    final first = container();
    await first.read(themeSettingsProvider.future);
    await first.read(themeSettingsProvider.notifier).setTheme(ThemeChoice.warm);
    await first
        .read(themeSettingsProvider.notifier)
        .setAccent(AccentChoice.green);

    final settings = await container().read(themeSettingsProvider.future);
    expect(settings.theme, ThemeChoice.warm);
    expect(settings.accent, AccentChoice.green);
  });

  test('unknown stored values fall back to defaults', () async {
    await db.writeSetting('theme', 'unknown');
    final settings = await container().read(themeSettingsProvider.future);
    expect(settings.theme, ThemeChoice.light);
  });

  test('theme modes and brightness', () {
    expect(AppTheme.modeFor(ThemeChoice.dark), ThemeMode.dark);
    expect(AppTheme.modeFor(ThemeChoice.system), ThemeMode.system);
    expect(AppTheme.modeFor(ThemeChoice.warm), ThemeMode.light);
    expect(
      AppTheme.dark(AccentChoice.blue).colorScheme.brightness,
      Brightness.dark,
    );
    final light = AppTheme.light(AccentChoice.blue);
    expect(light.colorScheme.primary, AccentChoice.blue.color);
    expect(light.scaffoldBackgroundColor, const Color(0xFFF5F7FA));
    expect(
      AppTheme.warm(AccentChoice.blue).scaffoldBackgroundColor,
      isNot(light.scaffoldBackgroundColor),
    );
  });

  test('accent drives primary, containers and navigation indicator', () {
    for (final build in [AppTheme.light, AppTheme.warm, AppTheme.dark]) {
      final blue = build(AccentChoice.blue);
      final green = build(AccentChoice.green);
      expect(green.colorScheme.primary, isNot(blue.colorScheme.primary));
      expect(
        green.colorScheme.secondaryContainer,
        isNot(blue.colorScheme.secondaryContainer),
      );
      expect(
        green.navigationBarTheme.indicatorColor,
        isNot(blue.navigationBarTheme.indicatorColor),
      );
    }
  });
}
