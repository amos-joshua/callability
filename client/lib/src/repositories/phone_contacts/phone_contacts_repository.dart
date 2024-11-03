import '../../model/contact.dart';

abstract class PhoneContactsRepository {
  Future<void> requestContactsPermission();
  Future<List<Contact>> getAllContacts();
  void onContactsChanged(void Function() callback);
}