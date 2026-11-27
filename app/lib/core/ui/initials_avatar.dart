import 'package:material_ui/material_ui.dart';

import 'color_palette.dart';

String initialsOf(String name) {
  final words = name
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty && RegExp(r'[A-Za-zÄÖÜäöü0-9]').hasMatch(w))
      .toList();
  if (words.isEmpty) return '?';
  final first = words.first.characters.first;
  final second = words.length > 1 ? words[1].characters.first : '';
  return (first + second).toUpperCase();
}

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.name,
    required this.color,
    this.size = 44,
  });

  final String name;
  final int? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fill = ColorPalette.resolve(color);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Text(
        initialsOf(name),
        style: TextStyle(
          color: ColorPalette.onColor(fill),
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
