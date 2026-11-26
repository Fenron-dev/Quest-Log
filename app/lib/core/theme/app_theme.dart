import 'package:flutter/material.dart';

enum ThemeChoice {
  light('Hell'),
  dark('Dunkel'),
  warm('Warm'),
  system('System');

  const ThemeChoice(this.label);
  final String label;
}

enum AccentChoice {
  blue('Blau', Color(0xFF1D5FD1)),
  teal('Petrol', Color(0xFF0E7C7B)),
  green('Grün', Color(0xFF2E7D32)),
  orange('Orange', Color(0xFFC2570C)),
  purple('Violett', Color(0xFF7B3FBF));

  const AccentChoice(this.label, this.color);
  final String label;
  final Color color;
}

class _Palette {
  const _Palette({
    required this.brightness,
    required this.background,
    required this.card,
    required this.border,
    required this.text,
    required this.mutedText,
  });

  final Brightness brightness;
  final Color background;
  final Color card;
  final Color border;
  final Color text;
  final Color mutedText;
}

const _light = _Palette(
  brightness: Brightness.light,
  background: Color(0xFFF5F7FA),
  card: Color(0xFFFFFFFF),
  border: Color(0xFFE1E6EC),
  text: Color(0xFF15202B),
  mutedText: Color(0xFF5B6B7C),
);

const _dark = _Palette(
  brightness: Brightness.dark,
  background: Color(0xFF0F1419),
  card: Color(0xFF1A2128),
  border: Color(0xFF2C3640),
  text: Color(0xFFE7ECF1),
  mutedText: Color(0xFF9AA8B5),
);

const _warm = _Palette(
  brightness: Brightness.light,
  background: Color(0xFFF7F2EA),
  card: Color(0xFFFFFCF7),
  border: Color(0xFFE6DCCD),
  text: Color(0xFF2B2118),
  mutedText: Color(0xFF6E5F50),
);

abstract final class AppTheme {
  /// Minimum size for interactive elements.
  static const double minTapTarget = 44;

  static ThemeData light(AccentChoice accent) => _build(_light, accent.color);

  static ThemeData warm(AccentChoice accent) => _build(_warm, accent.color);

  static ThemeData dark(AccentChoice accent) =>
      _build(_dark, _lighten(accent.color));

  /// Light variant used as `theme` for the given choice.
  static ThemeData lightFor(ThemeChoice choice, AccentChoice accent) =>
      choice == ThemeChoice.warm ? warm(accent) : light(accent);

  static ThemeMode modeFor(ThemeChoice choice) => switch (choice) {
    ThemeChoice.light || ThemeChoice.warm => ThemeMode.light,
    ThemeChoice.dark => ThemeMode.dark,
    ThemeChoice.system => ThemeMode.system,
  };

  static Color _lighten(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.lightness >= 0.65 ? color : hsl.withLightness(0.65).toColor();
  }

  static ThemeData _build(_Palette p, Color accent) {
    final isDark = p.brightness == Brightness.dark;
    final onAccent =
        ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
        ? Colors.white
        : Colors.black;
    final scheme =
        (isDark ? const ColorScheme.dark() : const ColorScheme.light())
            .copyWith(
              primary: accent,
              onPrimary: onAccent,
              secondary: accent,
              onSecondary: onAccent,
              surface: p.card,
              onSurface: p.text,
              onSurfaceVariant: p.mutedText,
              surfaceContainerLowest: p.background,
              surfaceContainer: p.card,
              outline: p.border,
              outlineVariant: p.border,
            );

    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.text,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: p.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.border),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.card,
        indicatorColor: accent.withValues(alpha: 0.16),
      ),
    );
  }
}
