import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../app.dart';
import '../blocs/presets/widgets.dart';
import '../utils/dialogs.dart';
import '../blocs/calls/calls.dart';
import '../model/model.dart';
import 'ui/settings_icon.dart';

class RootScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootScaffold({required this.navigationShell, super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  late final StreamSubscription? incomingCallSubscription;

  @override
  void initState() {
    super.initState();
    final currentCall = context.read<CurrentCallCubit>();
    incomingCallSubscription = currentCall.incomingCallStream.listen((event) {
      if (event == CallEvent.incomingCallStart) {
        final ctx = context;
        if (ctx.mounted) {
          ctx.go('/calls/incoming_call');
        }
      }
    });
  }

  @override
  void dispose() {
    incomingCallSubscription?.cancel();
    incomingCallSubscription = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(App.name),
        actions: const [
          SettingsIcon()
        ],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
                label: 'Groups',
                icon: Icon(Icons.group)
            ),
            BottomNavigationBarItem(
                label: 'Profiles',
                icon: Icon(Icons.list)
            ),
            BottomNavigationBarItem(
                label: 'Calls',
                icon: Icon(Icons.call)
            ),
            /*
              BottomNavigationBarItem(
                label: 'Contacts',
                icon: Icon(Icons.contacts)
              )*/
          ],
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) => widget.navigationShell.goBranch(index)
      ),
      floatingActionButton: widget.navigationShell.currentIndex == 0 ? const FloatingActionButton(
          onPressed:null,
          child: PresetOverridePopupButton()
      ) : widget.navigationShell.currentIndex == 3 ? FloatingActionButton(
        onPressed: () async {
          final currentCall = context.read<CurrentCallCubit>();
          final contact = await SelectContactsDialog(context).show([], singleChoice: true);
          if ((contact == null) || contact.isEmpty) return;
          if (context.mounted) {
            currentCall.select(contact.first);
            final call = await StartCallDialog(context).show();
            if (call == null) return;
            //callsCubit.saveCall(call);
            if (context.mounted) {
              currentCall.startCall(context, call);
            }
          }
        },
        child: const Icon(Icons.call),
      ) : null,
    );
  }
}