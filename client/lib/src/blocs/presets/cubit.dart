import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_settings/app_settings.dart';
import '../../repositories/repositories.dart';
import '../../model/model.dart';
import '../../utils/native_notifications.dart';
import 'state.dart';

class PresetsCubit extends Cubit<PresetsState> {
  final DBRepository database;
  final NativeNotifications nativeNotifications;
  final _cubits = <int, PresetCubit>{};

  PresetsCubit({required this.database, required this.nativeNotifications}): super(const PresetsState());

  Future<void> presetsModified() async {
    //nativeNotifications.updatePresets();
  }

  Future<void> list() async {
    emit(state.copyWith(loading: true));
    final presets = await database.presets();
    emit(state.copyWith(loading: false, presets: _sort(presets)));
  }

  Future<void> save(Preset preset) async {
    emit(state.copyWith(loading: true));
    database.savePresetSync(preset);
    final exists = state.presets.any((existing) => existing.id == preset.id);
    if (exists) {
      emit(state.copyWith(loading: false, presets: _sort(state.presets)));
    }
    else {
      emit(state.copyWith(presets: _sort([...state.presets, preset]), loading: false));
    }
    unawaited(presetsModified());
  }

  Future<void> remove(Preset preset) async {
    await database.removePreset(preset);
    emit(state.copyWith(presets: state.presets.where((existing) => existing.id != preset.id).toList()));
    unawaited(presetsModified());
  }

  Future<void> removePresetSettingsForGroup(ContactGroup group) async {
    final presets = await database.presets();
    for (final preset in presets) {
      final badSettings = <PresetSetting>[];
      for (final setting in preset.settings) {
        if (setting.group.targetId == group.id) {
          badSettings.add(setting);
        }
      }
      badSettings.forEach(preset.settings.remove);
      badSettings.forEach(database.removePresetSetting);
      database.savePresetSync(preset);
    }
  }

  Future<void> addPresetSettingsForGroup(ContactGroup group) async {
    final presets = await database.presets();
    for (final preset in presets) {
      if (!preset.settings.any((setting) => setting.group.targetId == group.id)) {
        final existingSetting = preset.settings.lastOrNull;
        final newPreset = PresetSetting()..group.target = group;
        if (existingSetting != null) {
          newPreset.leisureRingType = existingSetting.leisureRingType;
          newPreset.importantRingType = existingSetting.importantRingType;
          newPreset.urgentRingType = existingSetting.urgentRingType;
        }
        preset.settings.add(newPreset);
        database.savePresetSync(preset);
      }
    }
  }

  PresetCubit cubitFor(Preset preset, {required AppSettingsCubit appSettingsCubit}) {
    final existingCubit = _cubits[preset.id];
    if (existingCubit != null) return existingCubit;
    final cubit = PresetCubit(
      preset,
      appSettingsCubit: appSettingsCubit,
      presetsCubit: this,
      database: database
    );
    _cubits[preset.id] = cubit;
    return cubit;
  }

  List<Preset> _sort(List<Preset> presets) {
    presets.sort((a, b) => a.name.compareTo(b.name));
    return presets;
  }

  Future<String> nextPresetName() => database.nextPresetName();

  Future<bool> hasPresetNamed(String name) => database.hasPresetNamed(name);
}


class PresetSettingCubit extends Cubit<PresetSettingState> {
  final DBRepository database;
  final PresetsCubit presetsCubit;

  final Preset preset;
  PresetSettingCubit(this.preset, PresetSetting presetSetting, {required this.database, required this.presetsCubit}): super(PresetSettingState(presetSetting, ringTypesNonce: 0));

  void setRingTypeFor(CallUrgency urgency, {required RingType ringType}) {
    state.presetSetting.setRingTypeFor(urgency, ringType: ringType);
    database.savePresetSync(preset);
    emit(state.copyWith(ringTypesNonce: state.ringTypesNonce + 1));
    presetsCubit.presetsModified();
  }
}


class PresetCubit extends Cubit<PresetState> {
  final DBRepository database;
  final PresetsCubit presetsCubit;
  final AppSettingsCubit appSettingsCubit;
  final _presetSettingCubits = <int, PresetSettingCubit>{};

  PresetCubit(Preset preset, {required this.appSettingsCubit, required this.presetsCubit, required this.database}): super(PresetState(preset: preset));

  void updateName(String name) {
    state.preset.name = name;
    database.savePresetSync(state.preset);
    emit(state.copyWith(nameNonce: state.nameNonce+1));
    presetsCubit.presetsModified();
  }

  void addSchedule() {
    state.preset.schedules.add(Schedule(days: [1, 2, 3, 4, 5, 6, 7]));
    database.savePresetSync(state.preset);
    appSettingsCubit.determineActivePreset();
    emit(state.copyWith(schedulesNonce: state.schedulesNonce + 1));
    presetsCubit.presetsModified();
  }

  void removeSchedule(Schedule schedule) {
    state.preset.schedules.removeWhere((other) => other.id == schedule.id);
    database.savePresetSync(state.preset);
    appSettingsCubit.determineActivePreset();
    emit(state.copyWith(schedulesNonce: state.schedulesNonce + 1));
    presetsCubit.presetsModified();
  }
  
  void syncSettingsWithGroups() {
    database.syncSettingsWithGroups(state.preset);
    emit(state.copyWith(settingsNonce: state.settingsNonce+1));
    presetsCubit.presetsModified();
  }

  PresetSetting _newSettingForGroup(ContactGroup group) {
    final newSetting = PresetSetting()..group.target = group;
    state.preset.settings.add(newSetting);
    database.savePresetSync(state.preset);
    presetsCubit.presetsModified();
    return newSetting;
  }

  PresetSetting settingForGroup(ContactGroup group) {
    return state.preset.settingForGroup(group) ?? _newSettingForGroup(group);
  }

  PresetSettingCubit presetSettingCubitFor(ContactGroup group) {
    final setting = settingForGroup(group);
    final existingCubit = _presetSettingCubits[setting.id];
    if (existingCubit != null) return existingCubit;
    final cubit = PresetSettingCubit(state.preset, setting, database: database, presetsCubit: presetsCubit);
    _presetSettingCubits[setting.id] = cubit;
    return cubit;
  }

  static BlocBuilder builder(Widget Function(BuildContext, PresetState) cubitBuilder) => BlocBuilder<PresetCubit, PresetState>(
    builder: cubitBuilder
  );
}

