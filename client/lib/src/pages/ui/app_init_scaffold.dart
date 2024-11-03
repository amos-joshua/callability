import 'package:flutter/material.dart';
import '../../app.dart';
import 'settings_icon.dart';

class AppInitScaffold extends StatelessWidget {
  final Widget body;
  const AppInitScaffold({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text(App.name),
            actions: const [
              SettingsIcon(pushWithRouter: false)
            ],
          ),
          body: body
      ),
    );
  }
}