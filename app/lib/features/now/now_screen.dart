import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/router.dart';
import '../../core/ui/empty_state.dart';

class NowScreen extends StatelessWidget {
  const NowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jetzt'),
        actions: [
          IconButton(
            tooltip: 'Einstellungen',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('${AppRoutes.now}/settings'),
          ),
        ],
      ),
      body: const EmptyState(
        icon: Icons.bolt_outlined,
        message: 'Diese Ansicht folgt mit der Zeiterfassung.',
      ),
    );
  }
}
