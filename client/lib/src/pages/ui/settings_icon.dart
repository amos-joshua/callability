import 'package:Callability/src/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsIcon extends StatelessWidget {
  final bool pushWithRouter;
  const SettingsIcon({super.key, this.pushWithRouter = true});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        if (pushWithRouter) {
          context.push('/settings');
        }
        else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MaterialApp(
                  home: Scaffold(
                      body: SettingsPage()
                  )
              )
            )
          );
        }
      },
    );
  }

}