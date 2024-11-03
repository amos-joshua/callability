import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../model/model.dart';
import '../blocs/calls/calls.dart';
import 'ui/circular_icon_button.dart';

class OutgoingCallPage extends StatelessWidget {
  const OutgoingCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCall = context.watch<CurrentCallCubit>();

    final contact = currentCall.state.contact;
    final displayName = contact?.displayName ?? currentCall.state.email;
    final subject = currentCall.state.subject.trim();
    final callStatus = currentCall.state.callStatus;
    final callStatusString = switch(callStatus) {
      CallStatus.error => 'Error: ${currentCall.state.callError ?? 'unknown error'}',
      CallStatus.recipientNotRegistered => "$displayName doesn't have the app",
      CallStatus.notAnswered => 'No answer',
      CallStatus.rejected => 'Declined',
      _ => callStatus.label()
    };
    final callStatusColor = switch(callStatus) {
      CallStatus.error => Colors.red,
      CallStatus.recipientNotRegistered => Colors.blue,
      CallStatus.notAnswered => Colors.blue,
      CallStatus.rejected => Colors.orange,
      _ => Colors.black54
    };
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
            if (callStatus != CallStatus.answered) ...[
              Text(currentCall.state.urgency.label(), style: const TextStyle(color: Colors.black38, fontSize: 18.0)),
              if (subject.isNotEmpty) Text(subject, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0)),
              Text(callStatusString, textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, color: callStatusColor))
            ]
            else ...[
              const SizedBox(height: 60.0),
              Icon(Icons.check, size: 64, color: Colors.lightGreenAccent.shade200),
              Text('Call Accepted', style: TextStyle(fontSize: 24.0, color: callStatusColor)),
              if (contact != null) Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      FlutterContacts.openExternalView(contact.uid);
                    },
                    child: const Text('Show contact')
                ),
              )
            ],
            const SizedBox(height: 100.0),
            const Expanded(
                flex: 1,
                child: SizedBox()
            ),
            Align(
              alignment: Alignment.center,
              child: CircularIconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 64.0),
                backgroundColor: Colors.red.shade100.withOpacity(0.6),
                onPressed: () {
                  currentCall.outgoingCallHangUp();
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        )
    );
  }
}
