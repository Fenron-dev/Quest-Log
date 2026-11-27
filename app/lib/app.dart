import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_settings.dart';
import 'features/reminders/reminder_scheduler.dart';

class QuestLogApp extends ConsumerWidget {
  const QuestLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(themeSettingsProvider).value ?? const ThemeSettings();
    return MaterialApp.router(
      title: 'Quest-Log',
      theme: AppTheme.lightFor(settings.theme, settings.accent),
      darkTheme: AppTheme.dark(settings.accent),
      themeMode: AppTheme.modeFor(settings.theme),
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('de'),
      supportedLocales: const [Locale('de')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) => ReminderHost(child: child!),
    );
  }
}
