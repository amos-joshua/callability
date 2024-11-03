import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/model.dart';
import '../blocs/contacts/contacts.dart';
import '../repositories/repositories.dart';
import '../blocs/calls/calls.dart';

class AlertMessageDialog {
  final BuildContext context;
  AlertMessageDialog(this.context);

  Future<void> show({required String title, String? message}) {

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message ?? ''),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Ok')
            )
          ],
        )
    );
  }
}

class PromptDialog {
  final BuildContext context;
  PromptDialog(this.context);

  Future<String?> show({required String title, Future<String?> Function(String)? validator, String? value}) {
    final textFieldController = TextEditingController(text: value ?? '');
    final validate = validator ?? (value) => Future.value(null);
    final errorMessage = ValueNotifier<String?>(null);

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: ValueListenableBuilder(
            valueListenable: errorMessage,
            builder: (context, errMsg, tree) => TextField(
              controller: textFieldController,
              decoration: InputDecoration(
                errorText: errMsg
              ),
            )
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel')
            ),
            TextButton(
                onPressed: () async {
                  final value = textFieldController.text;
                  final err = await validate(value);
                  if (err != null) {
                    errorMessage.value = err;
                  }
                  else if (context.mounted) {
                    Navigator.of(context).pop(value);
                  }
                },
                child: const Text('Ok')
            )
          ],
        )
    );
  }
}


class SelectContactsDialog {
  final BuildContext context;
  SelectContactsDialog(this.context);

  Future<List<Contact>?> show(List<Contact> selected, {bool singleChoice = false}) {

    final contactsRepository = context.read<AllContactsRepository>();
    final contactsCubit = ContactsCubit(contactsRepository: contactsRepository);
    for (final contact in selected) {
      contactsCubit.toggleSelection(contact);
    }

    return showDialog<List<Contact>>(
        context: context,
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);

          return AlertDialog(
            title: singleChoice ? const Text('Select contact...') : const Text('Select contacts...'),
            content: SizedBox(
              height: mediaQuery.size.height,
              width: mediaQuery.size.width,
              child: BlocProvider.value(
                  value: contactsCubit,
                  child: ContactsListWithFilter(
                    allowSelection: true,
                    onSelect: singleChoice ? (contact) => Navigator.of(context).pop([contact]) : null,
                  )
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: const Text('Cancel')
              ),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(contactsCubit.state.selected);
                  },
                  child: const Text('Ok')
              )
            ],
          );
        }
    );
  }
}


class ConfirmDialog {
  final BuildContext context;
  ConfirmDialog(this.context);

  Future<bool> show({required String title, String? message}) async {
    final confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message ?? ''),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel')
            ),
            TextButton(
                onPressed: () {
                    Navigator.of(context).pop(true);
                },
                child: const Text('Ok')
            )
          ],
        )
    );

    return confirmed ?? false;
  }
}


class DurationSelectDialog {
  final BuildContext context;
  DurationSelectDialog(this.context);

  DropdownMenuItem<Duration> _option(int minutes, String label) => DropdownMenuItem(
    value: Duration(minutes:minutes),
    child: Text(label)
  );

  Future<Duration?> show({required String title, String? message}) {
    final durationNotifier = ValueNotifier(const Duration(hours:1));

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: ValueListenableBuilder(
            valueListenable: durationNotifier,
            builder: (context, duration, tree) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message ?? ''),
                DropdownButton(
                  value: duration,
                    items: [
                      _option(5, '5 Minutes'),
                      _option(10, '10 minutes'),
                      _option(15, '15 minutes'),
                      _option(30, '30 minutes'),
                      _option(45, '45 minutes'),
                      _option(60, '1 hour'),
                      _option(90, '1.5 hours'),
                      _option(120, '2 hours'),
                      _option(180, '3 hours'),
                    ].toList(growable: false),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        durationNotifier.value = newValue;
                      }
                    }
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel')
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(durationNotifier.value);
                },
                child: const Text('Ok')
            )
          ],
        )
    );
  }
}


class StartCallDialog {
  final BuildContext context;
  StartCallDialog(this.context);

  Future<Call?> show() async {
    final currentCallCubit = context.read<CurrentCallCubit>();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Call ${currentCallCubit.state.contact?.displayName ?? '(unknown contact)'}'),
          content: CallConfigurationPane(
            onCall: (call) {
              Navigator.of(context).pop(call);
            },
          ),
          actions: const [],
        )
    );
  }
}