import '../model/model.dart';
import 'storage.dart';

class InMemoryStorage extends Storage {
  List<Contact> _contacts = [];
  final List<ContactGroup> _groups = [];
  final List<Preset> _presets = [];
  final List<Call> _calls = [];
  var _appSetting = AppSettings();

  @override
  Future<void> initialize(String appSupportDirectory) async {
  }

  @override
  Future<List<Contact>> loadContacts() async {
    return _contacts;
  }

  @override
  Future<Contact?> getContactByUid(String uid) async {
    return _contacts.where((contact) => contact.uid == uid).firstOrNull;
  }

  @override
  Future<Contact?> getContactByEmail(String email) async {
    return _contacts.where((contact) => contact.emails.contains(email)).firstOrNull;
  }

  @override
  Future<void> saveContacts(List<Contact> contacts) async {
    _contacts = contacts;
  }

  @override
  Future<void> refreshContacts(List<Contact> contacts) async {
    _contacts = contacts;
  }

  @override
  Future<List<ContactGroup>> loadGroups() async {
    return _groups;
  }

  @override
  Future<void> removeGroup(ContactGroup group) async {
    _groups.remove(group);
  }

  @override
  Future<void> saveGroup(ContactGroup group) async {
    final groupIndex = _groups.indexOf(group);
    if (groupIndex != -1) {
      _groups[groupIndex] = group;
    }
    else {
      _groups.add(group);
    }
  }

  @override
  Future<void> clearContacts() async {
    _contacts.clear();
  }

  @override
  Future<void> removeContact(Contact contact) async {
    _contacts.remove(contact);
  }


  // Presets

  @override
  Future<List<Preset>> loadPresets() async {
    return _presets;
  }

  @override
  void savePresetSync(Preset preset) {
    _presets.add(preset);
  }

  @override
  Future<void> removePreset(Preset preset) async {
    _presets.remove(preset);
  }

  @override
  Future<void> removePresetSetting(PresetSetting setting) async {
    for (final preset in _presets) {
      preset.settings.remove(setting);
    }
  }

  @override
  AppSettings loadAppSettings() => _appSetting;

  @override
  Future<void> saveAppSettings(AppSettings appSettings) async {
    _appSetting = appSettings;
  }

  @override
  Future<void> saveSchedule(Schedule schedule) async {}

  @override
  Future<void> removeSchedule(Schedule schedule) async {
    for (final preset in _presets) {
      preset.schedules.remove(schedule);
    }
  }


  @override
  Future<List<Call>> calls() async => _calls;

  @override
  Future<void> saveCall(Call call) async => _calls.add(call);

  @override
  Future<void> clearCalls() async => _calls.clear();
}