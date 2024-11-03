import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_settings/app_settings.dart';
import '../../controller/controller.dart';
import '../../pages/ui/app_loading.dart';
import '../../pages/ui/app_init_scaffold.dart';
import 'cubit.dart';

class AppInitLoader extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  const AppInitLoader({required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    final appInit = context.watch<AppInitCubit>().state;
    if (appInit.initOngoing) {
      return const AppInitScaffold(
          body: AppLoading()
      );
    }

    final controller = context.read<Controller>();
    return AppSettingsCubit.provider(controller.appSettingsCubit,
        child: builder(context)
    );
  }
}