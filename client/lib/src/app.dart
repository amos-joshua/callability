import 'package:Callability/src/blocs/app_init/app_init.dart';
import 'package:flutter/material.dart';
import 'controller/controller.dart';
import 'dependencies.dart';
import 'pages/app_router_page.dart';

class App extends StatefulWidget {
  static const name = 'Callability';

  final Controller controller;
  const App({required this.controller, super.key});

  @override
  State createState() => _State();
}

class _State extends State<App> {
  Controller get controller => widget.controller;

  @override
  void initState() {
    controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DependenciesProvider(
        controller: controller,
        child: AppInitLoader(
            builder: (context) => const AppRouter()
        )
    );
  }

}