import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controller/controller.dart';

class DependenciesProvider extends StatelessWidget {
  final Widget child;
  final Controller controller;

  const DependenciesProvider({
    required this.controller,
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: controller.runtimeParameters),
        RepositoryProvider.value(value: controller.allContacts),
        RepositoryProvider.value(value: controller.database),
        RepositoryProvider.value(value: controller.nativeNotifications),
        RepositoryProvider.value(value: controller)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: controller.appInit),
          BlocProvider.value(value: controller.groups),
          BlocProvider.value(value: controller.presets),
          BlocProvider.value(value: controller.auth),
          BlocProvider.value(value: controller.calls),
          BlocProvider.value(value: controller.devices),
          BlocProvider.value(value: controller.currentCall)
          // NOTE: AppSettingsCubit is provided in AppInitLoader
        ],
        child: child
      ),
    );
  }
}

