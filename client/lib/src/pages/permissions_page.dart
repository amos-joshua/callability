
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/lifecycle_event_handler.dart';
import '../utils/native_notifications.dart';
import '../blocs/app_settings/app_settings.dart';
import '../app.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  late NativeNotifications nativeNotifications;

  late final lifecycleObserver = LifecycleEventHandler(
      resumeCallBack: () async {
        final appSettings = context.read<AppSettingsCubit>();

        final allowed = await nativeNotifications.hasPermissions();
        appSettings.updateNotificationPolicyAccessPermissions(allowed);
      }
  );

  @override
  void initState() {
    super.initState();
    nativeNotifications = context.read<NativeNotifications>();

    WidgetsBinding.instance.addObserver(lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(lifecycleObserver);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('${App.name} requires permissions to change your phone from silent to ring mode. You must enable the permission in the settings to continue:'),
        ),
        ElevatedButton(
            onPressed: () {
              nativeNotifications.requestPermissions();
            },
            child: const Text('Open settings')
        )
      ],
    );
  }
}