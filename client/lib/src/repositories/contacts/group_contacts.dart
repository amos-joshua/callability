import 'dart:async';

import 'contacts.dart';
import '../../model/model.dart';
import '../../storage/storage.dart';

class GroupContactsRepository extends ContactsRepository {
  final Storage storage;
  final ContactGroup _group;
  GroupContactsRepository(ContactGroup group, {required this.storage}): _group = group;

  @override
  Future<void> add(Contact contact) async {
    _group.contacts.add(contact);
    await storage.saveGroup(_group);
  }

  @override
  Future<List<Contact>> contacts(String filter) async {
    return _group.contacts.where((contact) => contact.matches(filter)).toList();
  }

  @override
  Future<void> refreshContacts(List<Contact> contacts) async {
    // no-op for groups
  }

  @override
  Future<Contact?> get(String uid) async => _group.contacts.where((contact) => contact.uid == uid).firstOrNull;

  @override
  Future<Contact?> getByEmail(String email) async => _group.contacts.where((contact) => contact.emails.contains(email)).firstOrNull;

  @override
  Future<void> remove(Contact contact) async {
    _group.contacts.remove(contact);
    await storage.saveGroup(_group);
  }

  @override
  Future<void> addAll(List<Contact> contacts) async {
    _group.contacts.addAll(contacts);
    await storage.saveGroup(_group);
  }

  @override
  Future<void> clear() async {
    _group.contacts.clear();
    await storage.saveGroup(_group);
  }


}