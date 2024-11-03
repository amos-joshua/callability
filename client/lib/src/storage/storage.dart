import 'dart:async';
import '../model/model.dart';

abstract class Storage {
  Future<void> initialize(String appSupportDirectory);

  Future<Contact?> getContactByUid(String uid);
  Future<Contact?> getContactByEmail(String email);
  Future<void> saveContacts(List<Contact> contacts);
  Future<void> refreshContacts(List<Contact> contacts);
  Future<List<Contact>> loadContacts();
  Future<void> removeContact(Contact contact);
  Future<void> clearContacts();

  Future<List<ContactGroup>> loadGroups();
  Future<void> saveGroup(ContactGroup group);
  Future<void> removeGroup(ContactGroup group);

  Future<List<Preset>> loadPresets();
  void savePresetSync(Preset preset);
  Future<void> removePreset(Preset preset);
  Future<void> removePresetSetting(PresetSetting setting);

  AppSettings loadAppSettings();
  Future<void> saveAppSettings(AppSettings appSettings);

  Future<void> saveSchedule(Schedule schedule);
  Future<void> removeSchedule(Schedule schedule);

  Future<List<Call>> calls();
  Future<void> saveCall(Call call);
  Future<void> clearCalls();
}