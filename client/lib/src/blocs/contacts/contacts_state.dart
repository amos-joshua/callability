import 'package:equatable/equatable.dart';

import '../../model/model.dart';

class ContactsState extends Equatable {
  final List<Contact> contacts;
  final List<Contact> selected;
  final bool loading;
  final String filter;

  const ContactsState({
    this.contacts = const [],
    this.selected = const [],
    this.loading = true,
    this.filter = ''
  });

  ContactsState copyWith({
    List<Contact>? contacts,
    List<Contact>? selected,
    bool? loading,
    String? filter
  }) => ContactsState(contacts: contacts ?? this.contacts, selected: selected ?? this.selected, loading: loading ?? this.loading, filter: filter ?? this.filter);

  @override
  List<Object> get props => [contacts, selected, loading, filter];
}
