import '../../model/model.dart';

abstract class ContactsRepository {
  Future<List<Contact>> contacts(String filter);
  Future<Contact?> get(String uid);
  Future<Contact?> getByEmail(String email);
  Future<void> add(Contact contact);
  Future<void> remove(Contact contact);
  Future<void> clear();
  Future<void> addAll(List<Contact> contacts);
  Future<void> refreshContacts(List<Contact> contacts);
}