
import 'package:flutter/material.dart';
import 'package:relative_time/relative_time.dart';

import '../blocs/auth/widgets.dart';
import '../routes.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
      return AuthLoader(
          builder: (context) {
            return MaterialApp.router(
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                RelativeTimeLocalizations.delegate,
              ],
              routerConfig: appRouter,
            );
          }
      );
  }
}