import 'package:objectbox/objectbox.dart';
import 'contact.dart';
import 'enums.dart';
import 'preset.dart';

@Entity()
class ContactGroup {
  static const catchAllGroupName = 'Others';

  @Id()
  int id;
  String name;
  bool catchAll;

  @Backlink('group')
  final contacts = ToMany<Contact>();

  ContactGroup({this.id = 0, required this.catchAll, required this.name});

  bool matches(String filter) => filter.isEmpty || name.contains(filter);

  bool isMember(Contact contact) => contacts.any((other) => other.id == contact.id);

  Map asMap() {
    return {
      'name': name,
      'catchAll': catchAll,
      'contacts': [... contacts.map((contact) => contact.asMap())]
    };
  }

  @override
  String toString() => 'ContactGroup($name, $id)';
}