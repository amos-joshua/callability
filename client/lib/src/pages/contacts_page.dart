import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/contacts/contacts.dart';
import '../repositories/repositories.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsRepository = context.read<AllContactsRepository>();
    return BlocProvider<ContactsCubit>(
      create: (BuildContext context) => ContactsCubit(contactsRepository: contactsRepository),
      child: const ContactsListWithFilter(),
    );
  }
}
