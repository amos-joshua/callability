import 'dart:async';

import '../storage/storage.dart';
import '../model/model.dart';
import '../utils/time_utils.dart';

class DBRepository {
  final Storage storage;
  Preset? _defaultPreset;

  DBRepository(this.storage);

  // AppSettings
  AppSettings appSettings() => storage.loadAppSettings();
  Future<void> saveAppSettings(AppSettings appSettings) => storage.saveAppSettings(appSettings);

  // Groups
  Future<List<ContactGroup>> groups(String filter) async {
    final groups = await storage.loadGroups();
    return groups.where((group) => group.matches(filter)).toList();
  }

  Future<void> saveGroup(ContactGroup group) => storage.saveGroup(group);

  Future<void> removeGroup(ContactGroup group) => storage.removeGroup(group);

  Future<bool> hasGroupNamed(String name) async {
    final groups = await storage.loadGroups();
    return groups.any((group) => group.name == name);
  }

  Future<String> nextGroupName() async {
    for (int i = 0; i < 100; i += 1) {
      final nextName = 'New Group $i';
      if (await hasGroupNamed(nextName) == false) {
        return nextName;
      }
    }
    return 'New Group';
  }

  // Presets
  Future<List<Preset>> presets() {
    return storage.loadPresets();
  }

  Preset _createDefaultPreset() {
    final preset = Preset(name: Preset.defaultPresetName, isDefault: true);
    storage.savePresetSync(preset);
    return preset;
  }

  Future<Preset> defaultPreset() async {
    final existingDefault = _defaultPreset;
    if (existingDefault != null) {
      return existingDefault;
    }

    final allPresets = await presets();
    return allPresets.firstWhere((preset) => preset.isDefault, orElse: _createDefaultPreset);
  }
  
  void savePresetSync(Preset preset) => storage.savePresetSync(preset);

  Future<void> removePreset(Preset preset) => storage.removePreset(preset);

  Future<bool> hasPresetNamed(String name) async {
    final presets = await storage.loadPresets();
    return presets.any((preset) => preset.name == name);
  }

  Future<String> nextPresetName() async {
    for (int i = 0; i < 100; i += 1) {
      final nextName = 'New Preset $i';
      if (await hasPresetNamed(nextName) == false) {
        return nextName;
      }
    }
    return 'New Preset';
  }

  Future<void> removePresetSetting(PresetSetting setting) async => storage.removePresetSetting(setting);

  Future<ContactGroup> groupForContact(Contact? contact) async {
    final allGroups = await groups('');
    final catchAll =  allGroups.where((group) => group.catchAll).first;
    if (contact == null) {
      return catchAll;
    }
    final matchingGroup = allGroups
          .where((group) => group.isMember(contact))
          .firstOrNull;
    return matchingGroup ?? catchAll;
  }

  Future<ActivePresetData> determineActivePreset() async {
    final settings = appSettings();

    final overridePreset = settings.presetOverride.target;
    final now = DateTime.now();

    late ActivePresetData activePresetData;
    if ((overridePreset != null) && (settings.presetOverrideStart.isBefore(now) && settings.presetOverrideEnd.isAfter(now))) {
      activePresetData = ActivePresetData(preset: overridePreset, isOverride: true, endTime: settings.presetOverrideEnd);
    }
    else {
      final defaultPreset = await this.defaultPreset();
      activePresetData = ActivePresetData(preset: defaultPreset, isOverride: false, endTime: DateTime.fromMillisecondsSinceEpoch(0));

      final presets = await this.presets();
      for (final preset in presets) {
        final activeSchedule = preset.activeScheduleAt(now);
        if (activeSchedule != null) {
          final endTime = now.atTimeOfDay(activeSchedule.endTime);
          activePresetData = ActivePresetData(preset: preset, isOverride: false, endTime: endTime);
          break;
        }
      }
    }
    
    return activePresetData;
  }
  
  // Groups
  Future<void> syncSettingsWithGroups(Preset preset) async {
    final allGroups = await storage.loadGroups();
    final staleSettings = <PresetSetting>[];

    // Remove settings that correspond to non-existent groups
    for (final setting in preset.settings) {
      if (!allGroups.any((group) => setting.belongsToGroup(group))) {
        staleSettings.add(setting);
      }
    }
    for (final staleSetting in staleSettings) {
      preset.settings.remove(staleSetting);
      storage.removePresetSetting(staleSetting);
    }

    // Add new settings for missing groups
    for (final group in allGroups) {
      final existingSetting = preset.settings.cast<PresetSetting?>().firstWhere((setting) => setting?.belongsToGroup(group) == true, orElse: () => null);
      if (existingSetting == null) {
        final newSetting = PresetSetting()..group.target = group;
        preset.settings.add(newSetting);
      }
      savePresetSync(preset);
    }
  }

  // Schedules
  Future<void> saveSchedule(Schedule schedule) => storage.saveSchedule(schedule);
  Future<void> removeSchedule(Schedule schedule) => storage.removeSchedule(schedule);

  // Calls
  Future<List<Call>> calls() => storage.calls();
  Future<void> saveCall(Call call) => storage.saveCall(call);
  Future<void> clearCalls() => storage.clearCalls();
}