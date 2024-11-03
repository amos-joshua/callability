import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts.dart';
import '../../model/model.dart';


class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final  Icon? trailingIcon;
  final void Function()? onTap;
  final void Function()? onTrailing;
  const ContactTile(this.contact, {this.isSelected = false, this.onTap, this.trailingIcon, this.onTrailing, super.key});

  @override
  Widget build(BuildContext context) {
    final trailingIcon = this.trailingIcon;
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: Text(contact.displayName),
      subtitle: Text(contact.emails.isEmpty ? '(no email)' : contact.emails.join(', ')),
      selected: isSelected,
      trailing: trailingIcon == null ? null : IconButton(
        icon: trailingIcon,
        onPressed: onTrailing,
      ),
      onTap: onTap,
    );
  }
}

class ContactsList extends StatelessWidget {
  final bool allowSelection;
  final bool allowDelete;
  final void Function(Contact)? onSelect;

  const ContactsList({required this.allowSelection, this.allowDelete = false, this.onSelect, super.key});

  Widget loadingSpinner() => const Center(
      child: CircularProgressIndicator()
  );

  Widget emptyList() => const Center(
    child: Text('(none)', style: TextStyle(color: Colors.black45))
  );

  Widget listView(ContactsState state) => ListView.builder(
      itemCount: state.contacts.length,
      itemBuilder: (context, index) {
        final contact = state.contacts[index];
        final onSelect = this.onSelect;
        return ContactTile(
          key: ValueKey(contact.id),
          contact,
          isSelected: state.selected.any((selected) => selected.id == contact.id),
          onTap: allowSelection ? () {
            if (onSelect != null) {
              onSelect(contact);
            }
            context.read<ContactsCubit>().toggleSelection(contact);
          } : null,
          trailingIcon: allowDelete ? const Icon(Icons.delete) : null,
          onTrailing: allowDelete ? () {
            context.read<ContactsCubit>().remove(contact);
            final snackBar = SnackBar(
              content: ListTile(
                title: Text("Removed '${contact.displayName}'", style: TextStyle(color: Colors.white),),
                trailing: TextButton(
                  child: const Text('undo'),
                  onPressed: () {
                    context.read<ContactsCubit>().add(contact);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                )
              )
            );
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } : null
        );
      }
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          return state.loading ? loadingSpinner() : state.contacts.isEmpty ? emptyList() : listView(state);
        }
  );
}

class ContactsFilterTextField extends StatelessWidget {
  final filterController = TextEditingController();

  ContactsFilterTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        if (state.filter.isEmpty && (state.contacts.length < 5)) {
          return const SizedBox();
        }
        filterController.text = state.filter;

        return TextField(
          controller: filterController,
          onChanged: (filter) => context.read<ContactsCubit>().list(filter.toLowerCase()),
          decoration: InputDecoration(
            hintText: 'Filter...',
            hintStyle: const TextStyle(color: Colors.black38),
            suffix: state.filter.isEmpty ? null : IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                filterController.text = '';
                context.read<ContactsCubit>().list('');
              },
            ),
            border: InputBorder.none
          ),
        );
      }
    );
  }
}

class ContactsListWithFilter extends StatelessWidget {
  final bool allowSelection;
  final bool allowDelete;
  final void Function(Contact)? onSelect;
  const ContactsListWithFilter({this.allowSelection = false, this.allowDelete = false, this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ContactsFilterTextField(),
        ),
        const ContactsCountBanner(),
        Expanded(
            child: ContactsList(
              allowSelection: allowSelection,
              allowDelete: allowDelete,
              onSelect: onSelect,
            )
        )
      ]
    );
  }

}

class ContactsCountBanner extends StatelessWidget {
  const ContactsCountBanner({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContactsCubit, ContactsState>(
    builder: (context, state) {
      final hasSelected = state.selected.isNotEmpty;
      final text = hasSelected ? '${state.selected.length} selected' : '${state.contacts.length} contacts';
      return ListTile(
        dense: true,
        title: hasSelected ? Text(text) : null,
        trailing: hasSelected ? TextButton(
            onPressed: () {
              context.read<ContactsCubit>().clearSelection();
            },
            child: const Text('clear')
        ) : Text(text),
      );
  });

}