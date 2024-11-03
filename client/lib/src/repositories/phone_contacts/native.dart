
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:logging_flutter/logging_flutter.dart';
import '../../model/model.dart';
import 'phone_contacts_repository.dart';

class NativePhoneContactsRepository implements PhoneContactsRepository {
  var hasPermission = false;

  @override
  Future<void> requestContactsPermission() async {
    hasPermission = await fc.FlutterContacts.requestPermission(readonly: true);
    if (!hasPermission) {
      Flogger.w('contacts permission denied!');
    }
  }

  @override
  Future<List<Contact>> getAllContacts() async {
    if (!hasPermission) {
      Flogger.w('tried accessing contacts without permission, returning an empty list');
      return [];
    }

    final contacts = await fc.FlutterContacts.getContacts(
        withProperties: true, withPhoto: false);

    return contacts.map((contact) => Contact(
      id: 0, // id 0 is used to insert new objects
      uid: contact.id,
      displayName: contact.displayName,
      firstName: contact.name.first,
      lastName: contact.name.last,
      emails: contact.emails.map((email) => email.address).toList(growable: false),
      phoneNumbers: contact.phones.map((phone) => phone.number).toList(growable: false),
      lastUpdated: DateTime.now()
    )).toList(growable: false);
  }

  @override
  void onContactsChanged(void Function() callback) {
    fc.FlutterContacts.addListener(callback);
  }
}