import 'package:logging_flutter/logging_flutter.dart';

import 'storage.dart';
import '../model/model.dart';
import '../../objectbox.g.dart'; // created by `dart run build_runner build`

class PersistentStorage implements Storage {
  late final Store _store;
  late final Box<Contact> _contacts;
  late final Box<ContactGroup> _groups;
  late final Box<Preset> _presets;
  late final Box<PresetSetting> _presetSettings;
  late final Box<Schedule> _schedules;
  late final Box<AppSettings> _appSettings;
  late final Box<Call> _calls;
  //late Admin _admin;

  @override
  Future<void> initialize(String appSupportDirectory) async {
    if (Store.isOpen(appSupportDirectory)) {
      _store = Store.attach(getObjectBoxModel(), appSupportDirectory);
    }
    else {
      _store = await openStore(directory: appSupportDirectory);
    }
    _contacts = _store.box<Contact>();
    _groups = _store.box<ContactGroup>();
    _presets = _store.box<Preset>();
    _presetSettings = _store.box<PresetSetting>();
    _schedules = _store.box<Schedule>();
    _appSettings = _store.box<AppSettings>();
    _calls = _store.box<Call>();

    //if (Admin.isAvailable()) {
    //
    //Keep a reference until no longer needed or manually closed.
    //
    // _admin = Admin(_store);
    //
    //}
  }

  // Contacts
  @override
  Future<void> clearContacts() async {
    _contacts.removeAll();
  }

  @override
  Future<void> removeContact(Contact contact) async {
    _contacts.remove(contact.id);
  }

  @override
  Future<List<Contact>> loadContacts()async {
    return _contacts.getAll();
  }

  @override
  Future<void> saveContacts(List<Contact> contacts) async {
    _contacts.removeAll();
    _contacts.putMany(contacts);
  }

  @override
  Future<void> refreshContacts(List<Contact> contacts) async {
    Flogger.i('Contacts DB changed, updating contacts', loggerName: 'CONTACTS');
    final updateThreshold = DateTime.now();
    contacts.forEach(updateContact);
    final deletedContacts = _contacts.query(Contact_.lastUpdated.lessThanDate(updateThreshold)).build().find();
    _contacts.removeMany(deletedContacts.map((contact) => contact.id).toList());
  }

  void updateContact(Contact freshContact) {
    final existingContact = _contacts.query(Contact_.uid.equals(freshContact.uid)).build().findFirst();
    if (existingContact != null) {
      existingContact.updateFrom(freshContact);
      _contacts.put(existingContact);
    }
    else {
      freshContact.lastUpdated = DateTime.now();
      _contacts.put(freshContact);
    }
  }

  @override
  Future<Contact?> getContactByUid(String uid) async {
    return _contacts.query(Contact_.uid.equals(uid)).build().findFirst();
  }

  @override
  Future<Contact?> getContactByEmail(String email) async {
    return _contacts.query(Contact_.emails.containsElement(email)).build().findFirst();
  }

  // Groups

  @override
  Future<List<ContactGroup>> loadGroups() async {
    return _groups.getAll();
  }

  @override
  Future<void> removeGroup(ContactGroup group) async {
    _groups.remove(group.id);
  }

  @override
  Future<void> saveGroup(ContactGroup group) async {
    _groups.put(group);
  }


  // Presets

  @override
  Future<List<Preset>> loadPresets() async {
    return _presets.getAll();
  }

  @override
  void savePresetSync(Preset preset) {
    _presets.put(preset);
    preset.settings.forEach(_presetSettings.put);
    preset.schedules.forEach(_schedules.put);
  }

  @override
  Future<void> removePreset(Preset preset) async => _presets.remove(preset.id);

  @override
  Future<void> removePresetSetting(PresetSetting setting) async => _presetSettings.remove(setting.id);

  @override
  AppSettings loadAppSettings() {
    var appSettings = _appSettings.getAll().firstOrNull;
    if (appSettings != null) {
      return appSettings;
    }
    appSettings = AppSettings();
    _appSettings.put(appSettings);
    return appSettings;
  }

  @override
  Future<void> saveAppSettings(AppSettings appSettings) async {
    _appSettings.put(appSettings);
  }


  @override
  Future<void> saveSchedule(Schedule schedule) async {
    _schedules.put(schedule);
  }

  @override
  Future<void> removeSchedule(Schedule schedule) async => _schedules.remove(schedule.id);

  @override
  Future<List<Call>> calls() async => _calls.getAll();

  @override
  Future<void> saveCall(Call call) async => _calls.put(call);

  @override
  Future<void> clearCalls() async => _calls.removeAll();

}