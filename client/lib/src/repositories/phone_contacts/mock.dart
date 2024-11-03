
import '../../model/contact.dart';
import '../../sample_data/contacts.dart';
import 'phone_contacts_repository.dart';

class MockPhoneContactsRepository implements PhoneContactsRepository {
  @override
  Future<void> requestContactsPermission() async {
  }

  @override
  Future<List<Contact>> getAllContacts() async => sampleContacts;

  @override
  void onContactsChanged(void Function() callback) {
    // no-op for mock repository
  }
}