import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/model.dart';
import '../blocs/calls/calls.dart';
import 'ui/circular_icon_button.dart';

class IncomingCallPage extends StatefulWidget {
  const IncomingCallPage({super.key});

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  StreamSubscription? callEvents;

  @override void initState() {
    super.initState();
    final currentCall = context.read<CurrentCallCubit>();
    final ctx = context;
    currentCall.incomingCallStream.listen((event) {
      if ([CallEvent.incomingCallHangUp, CallEvent.incomingCallRejected, CallEvent.incomingCallAccepted].contains(event)) {
        if (ctx.mounted) {
          final snackText = event == CallEvent.incomingCallAccepted ? 'Call accepted' : event == CallEvent.incomingCallRejected ? 'Call rejected' : 'Receiver hung up';
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(snackText)));
          Navigator.of(ctx).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCall = context.watch<CurrentCallCubit>();
    final displayName = currentCall.state.contact?.displayName ?? currentCall.state.email;
    final subject = currentCall.state.subject.trim();

    return Container(
        color: currentCall.state.urgency.color(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
                flex: 1,
                child: SizedBox()
            ),
            const Icon(Icons.account_circle, size: 96.0),
            Text(displayName, style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 32.0),
            //Text(currentCall.state.callUuid),
            Text(currentCall.state.urgency.label(), style: const TextStyle(color: Colors.black38, fontSize: 18.0)),
            if (subject.isNotEmpty) Text(subject, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0)),
            const SizedBox(height: 100.0),
            const Expanded(
                flex: 1,
                child: SizedBox()
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                CircularIconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 64.0),
                  backgroundColor: Colors.red.shade100.withOpacity(0.6),
                  onPressed: () {
                    currentCall.rejectCall();
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                CircularIconButton(
                  icon: const Icon(Icons.phone, color: Colors.lightGreen, size: 64.0),
                  backgroundColor: Colors.green.shade100,
                  onPressed: () {
                    currentCall.acceptCall();
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 50.0),
          ],
        )
    );
  }
}

