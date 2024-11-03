import 'package:objectbox/objectbox.dart';
import 'enums.dart';
import 'group.dart';

@Entity()
class Contact {
  @Id()
  int id;

  @Index()
  String uid;

  String firstName;
  String lastName;
  String displayName;
  List<String> emails;
  List<String> phoneNumbers;
  DateTime lastUpdated;

  
  Contact({
    this.id = 0,
    String? uid,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.emails,
    required this.lastUpdated
  }): uid = uid ?? '$id';

  bool matches(String filter) {
    return filter.isEmpty ||
        displayName.toLowerCase().contains(filter) ||
        firstName.toLowerCase().contains(filter) ||
        lastName.toLowerCase().contains(filter) ||
        phoneNumbers.any((number) => number.contains(filter)) ||
        emails.any((email) => email.toLowerCase().contains(filter));
  }

  final group = ToOne<ContactGroup>();

  void updateFrom(Contact other) {
    firstName = other.firstName;
    lastName = other.lastName;
    displayName = other.displayName;
    emails = other.emails;
    phoneNumbers = other.phoneNumbers;
    lastUpdated = DateTime.now();
  }

  Map asMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'emails': emails,
      'phoneNumbers': phoneNumbers
    };
  }

  @override
  String toString() => 'Contact($id, $uid, $displayName)';
}