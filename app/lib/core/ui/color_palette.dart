import 'package:flutter/material.dart';

/// A named colour for customers and projects. The name is shown next to the
/// swatch so colours can be told apart without relying on colour vision.
class PaletteColor {
  const PaletteColor(this.label, this.color);

  final String label;
  final Color color;

  int get value => color.toARGB32();
}

abstract final class ColorPalette {
  static const colors = [
    PaletteColor('Blau', Color(0xFF1D5FD1)),
    PaletteColor('Himmel', Color(0xFF0284C7)),
    PaletteColor('Petrol', Color(0xFF0E7C7B)),
    PaletteColor('Grün', Color(0xFF2E7D32)),
    PaletteColor('Limette', Color(0xFF65A30D)),
    PaletteColor('Senf', Color(0xFFB7860B)),
    PaletteColor('Orange', Color(0xFFC2570C)),
    PaletteColor('Rot', Color(0xFFC62828)),
    PaletteColor('Pink', Color(0xFFDB2777)),
    PaletteColor('Violett', Color(0xFF7B3FBF)),
    PaletteColor('Indigo', Color(0xFF4338CA)),
    PaletteColor('Schiefer', Color(0xFF64748B)),
  ];

  /// Fallback for records without a colour.
  static const neutral = Color(0xFF8A96A3);

  static Color resolve(int? value) => value == null ? neutral : Color(value);

  static String? labelFor(int? value) {
    for (final c in colors) {
      if (c.value == value) return c.label;
    }
    return null;
  }

  static Color onColor(Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.dark
      ? Colors.white
      : Colors.black;
}
