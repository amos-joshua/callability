import 'package:flutter/material.dart';

class SettingsScaffold extends StatelessWidget {
  final Widget body;
  const SettingsScaffold({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: body
    );
  }
}