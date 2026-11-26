import 'package:flutter/material.dart';

class MyDayScreen extends StatelessWidget {
  const MyDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Tag')),
      body: const SizedBox.expand(),
    );
  }
}
