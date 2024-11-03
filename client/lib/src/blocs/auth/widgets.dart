import 'package:Callability/src/pages/permissions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_settings/app_settings.dart';
import '../../pages/login_page.dart';
import '../../pages/ui/app_init_scaffold.dart';
import 'cubit.dart';

class AuthLoader extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  const AuthLoader({required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    if (!authCubit.state.authorized) {
      return const AppInitScaffold(body: LoginPage());
    }

    final appSettingsCubit = context.watch<AppSettingsCubit>();
    if (!appSettingsCubit.state.appSettings.hasNotificationPolicyAccessPermissions) {
      return const AppInitScaffold(body: PermissionsPage());
    }

    return builder(context);
  }
}