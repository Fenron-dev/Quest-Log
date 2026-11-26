import 'package:flutter/material.dart';

import '../../core/ui/empty_state.dart';

class MyDayScreen extends StatelessWidget {
  const MyDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Tag')),
      body: const EmptyState(
        icon: Icons.today_outlined,
        message: 'Diese Ansicht folgt mit der Zeiterfassung.',
      ),
    );
  }
}
