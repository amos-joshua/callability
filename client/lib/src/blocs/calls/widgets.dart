import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relative_time/relative_time.dart';

import '../../model/model.dart';
import '../../utils/string_utils.dart';
import '../../utils/dialogs.dart';
import 'calls.dart';
import 'cubit.dart';

class CallConfigurationPane extends StatelessWidget {
  final void Function(Call?) onCall;
  const CallConfigurationPane({required this.onCall, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Send a(n)'),
        //const CallDurationSelector(),
        const CallUrgencySelector(),
        CallButton(
          onCall: onCall,
        ),
        const CallSubjectField(),
      ],
    );
  }
}



class CallUrgencySelector extends StatelessWidget {
  const CallUrgencySelector({super.key});

  ButtonSegment _buttonSegment(CallUrgency urgency) => ButtonSegment<CallUrgency>(
      value: urgency,
      label: Text(urgency.label().capitalized, style: TextStyle(color: urgency.color()))
  );

  @override
  Widget build(BuildContext context) {
    final currentCall = context.watch<CurrentCallCubit>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SegmentedButton(
        showSelectedIcon: false,
        segments: [
          _buttonSegment(CallUrgency.leisure),
          _buttonSegment(CallUrgency.important),
          _buttonSegment(CallUrgency.urgent),
        ],
        selected: {currentCall.state.urgency},
        onSelectionChanged: (selection) {
          currentCall.update(urgency: selection.first);
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        )
      )
    );
  }
}

class CallSubjectField extends StatelessWidget {
  const CallSubjectField({super.key});
  
  @override
  Widget build(BuildContext context) {
    final currentCall = context.read<CurrentCallCubit>();
    final controller = TextEditingController();
    controller.text = currentCall.state.subject;
    
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'About...',
            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
            border: InputBorder.none
          ),
          onChanged: (newValue) {
            currentCall.update(subject: newValue.trim());
          }
        )
    );
  }
}


class CallButton extends StatelessWidget {
  final void Function(Call?) onCall;
  const CallButton({required this.onCall, super.key});

  @override
  Widget build(BuildContext context) {
    final currentCall = context.watch<CurrentCallCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              onCall(currentCall.createCall(outgoing: true));
            },
            style: ElevatedButton.styleFrom(backgroundColor: currentCall.state.urgency.color()),
            child: const Text('call', style: TextStyle(color: Colors.white))),
      ),
    );
  }
}

class CallTile extends StatelessWidget {
  final Call call;
  const CallTile({required this.call, super.key});

  @override
  Widget build(BuildContext context) {
    final contact = call.contact.target;
    return ListTile(
      leading: const Icon(Icons.account_circle_rounded),
      title: Text(call.contact.target?.displayName ?? '(unknown)'),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: call.outgoing ? const Icon(Icons.call_made, size: 16.0) : const Icon(Icons.call_received, size: 16.0),
          ),
          Text('${call.urgency.label()}: ', style: TextStyle(color: call.urgency.color())),
          Expanded(child: Text(RelativeTime(context).format(call.startTime))),
        ],
      ),
      trailing: IconButton(
          onPressed: contact == null ? null : () async {
            final currentCall = context.read<CurrentCallCubit>();
            final callsCubit = context.read<CallsCubit>();
            currentCall.select(contact);
            currentCall.update(
              urgency: call.urgency,
            );
            final newCall = await StartCallDialog(context).show();
            if (newCall == null) return;
            if (context.mounted) {
              currentCall.startCall(context, newCall);
            }
          },
          icon: const Icon(Icons.call)
      ),
    );
  }
}

class CallsList extends StatelessWidget {
  const CallsList({super.key});

  @override
  Widget build(BuildContext context) {
    final callsCubit = context.watch<CallsCubit>();

    if (callsCubit.state.calls.isEmpty) {
      return const Center(
        child: Text('(no calls)', style: TextStyle(color: Colors.grey),),
      );
    }

    final calls = callsCubit.state.calls.reversed.toList();
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return CallTile(
          key: ValueKey('call_${call.id}'),
          call: call,
        );
      }
    );
  }

}

