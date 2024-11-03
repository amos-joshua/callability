import '../../model/model.dart';
import '../../storage/storage.dart';
import 'group_contacts.dart';
import 'contacts.dart';

class AllContactsRepository extends ContactsRepository {
  final Storage storage;

  AllContactsRepository(this.storage);

  @override
  Future<void> addAll(List<Contact> contacts) => storage.saveContacts(contacts);

  @override
  Future<void> refreshContacts(List<Contact> contacts) => storage.refreshContacts(contacts);

  @override
  Future<List<Contact>> contacts(String filter) async {
    final contacts = await storage.loadContacts();
    return contacts.where((contact) => contact.matches(filter)).toList();
  }

  @override
  Future<void> add(Contact contact) => storage.saveContacts([contact]);

  @override
  Future<void> remove(Contact contact) => storage.removeContact(contact);

  @override
  Future<void> clear() => storage.clearContacts();

  @override
  Future<Contact?> get(String uid) => storage.getContactByUid(uid);

  @override
  Future<Contact?> getByEmail(String email) => storage.getContactByEmail(email);

  GroupContactsRepository groupContactsRepository(ContactGroup group) => GroupContactsRepository(group, storage: storage);
}