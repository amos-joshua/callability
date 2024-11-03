import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:provider/provider.dart';
import '../repositories/repositories.dart';
import '../utils/dialogs.dart';
import '../blocs/devices/devices.dart';
import '../blocs/auth/auth.dart';
import '../app.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void signOut(BuildContext context) async {
    final confirm = await ConfirmDialog(context).show(title: 'Sign out?');
    if (confirm) {
      FirebaseAuth.instance.signOut();
    }
  }

  void deleteAccount(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    final confirm = await ConfirmDialog(context).show(title: 'Completely delete account?');
    if (confirm) {
      await authCubit.deleteUserData();
      FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final runtimeParameters = context.read<RuntimeParametersRepository>();
    final authCubit = context.read<AuthCubit>();

    return ListView(
      children: [
        ListTile(
          title: const Text(App.name),
          subtitle: SelectableText(runtimeParameters.version),
        ),
        ListTile(
          title: const Text('Logs'),
          trailing: const Icon(Icons.text_snippet),
          onTap: () {
            LogConsole.open(context);
          },
        ),
        ListTile(
            trailing: const Icon(Icons.info),
            title: const Text('Licenses'),
            onTap: () {
              showLicensePage(
                  applicationName: App.name,
                  applicationVersion: runtimeParameters.version,
                  applicationLegalese: 'Copyright (C) 2024 Amos JOSHUA\nReleased under the  GNU GENERAL PUBLIC LICENSE Version 3',
                  context: context
              );
            }
        ),
        const Divider(),
        ExpansionTile(
          trailing: const Icon(Icons.devices),
          title: const Text('Devices'),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300.0
              ),
                child: const DeviceList()
            )
          ],
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          subtitle: Text(authCubit.state.identifier),
          onTap: () => signOut(context)
        ),
        ListTile(
          leading: const Icon(Icons.no_accounts),
          title: const Text('Delete account', style: TextStyle(color: Colors.red)),
          onTap: () => deleteAccount(context),
        )
      ],
    );
  }



}