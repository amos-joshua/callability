import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import '../../model/model.dart';
import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactsRepository _contactsRepository;

  ContactsCubit({required contactsRepository}): _contactsRepository = contactsRepository, super(const ContactsState()) {
    list('');
  }

  Future<void> list(String filter) async {
     emit(state.copyWith(loading: true, filter: filter));
     final contacts = await _contactsRepository.contacts(filter);
     emit(state.copyWith(loading: false, contacts: contacts, filter: filter));
  }

  Future<void> add(Contact contact) async {
    await _contactsRepository.add(contact);
    emit(state.copyWith(contacts: _sortContactList([...state.contacts, contact])));
  }

  Future<void> remove(Contact contact) async {
    await _contactsRepository.remove(contact);
    emit(state.copyWith(contacts: state.contacts.where((existing) => existing.id != contact.id).toList()));
  }

  void toggleSelection(Contact contact) {
    final isSelected = state.selected.any((selected) => selected.id == contact.id);
    if (isSelected) {
      final selected = state.selected.where((selected) => selected.id != contact.id).toList();
      emit(state.copyWith(selected: _sortContactList(selected)));
    }
    else {
      final selected = [...state.selected, contact];
      emit(state.copyWith(selected: selected));
    }
  }

  void clearSelection() {
    emit(state.copyWith(selected: []));
  }

  Future<void> replaceContacts(List<Contact> contacts) async {
    emit(state.copyWith(loading: true));
    await _contactsRepository.clear();
    final sortedContacts = _sortContactList([...contacts]);
    await _contactsRepository.addAll(sortedContacts);
    emit(state.copyWith(loading: false, contacts: sortedContacts));
  }

  List<Contact> _sortContactList(List<Contact> contacts) {
    contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    return contacts;
  }

  Future<void> updateContacts(List<Contact> contact) async {


  }
}
