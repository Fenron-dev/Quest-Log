import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvp/fvp.dart' as fvp;

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // video_player has no Windows/Linux backend; fvp provides one there.
  // Android and macOS keep the official implementation.
  fvp.registerWith(
    options: {
      'platforms': ['windows', 'linux'],
    },
  );
  runApp(const ProviderScope(child: QuestLogApp()));
}
