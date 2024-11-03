
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

import 'state.dart';
import '../../repositories/repositories.dart';
import '../../model/model.dart';
import '../../utils/native_notifications.dart';
import '../../utils/time_utils.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final DBRepository _database;
  final NativeNotifications _nativeNotifications;
  AppSettingsCubit({
    required DBRepository database,
    required NativeNotifications nativeNotifications,
    required ActivePresetData activePresetData
  }):
        _database = database, 
        _nativeNotifications = nativeNotifications, 
        super(AppSettingsState(activePresetData: activePresetData, database.appSettings()));

  void clearOverridePreset() async {
    state.appSettings.presetOverride.target = null;
    state.appSettings.presetOverrideStart = DateTime.fromMicrosecondsSinceEpoch(0);
    state.appSettings.presetOverrideEnd = DateTime.fromMillisecondsSinceEpoch(0);
    _database.saveAppSettings(state.appSettings);
    final activePresetData = await determineActivePreset();
    //_nativeNotifications.updatePresets();
    emit(state.copyWith(activePresetData: activePresetData));
  }

  void overridePreset(Preset preset, Duration duration) {
    state.appSettings.presetOverride.target = preset;
    state.appSettings.presetOverrideStart = DateTime.now();
    state.appSettings.presetOverrideEnd = DateTime.now().add(duration);
    _database.saveAppSettings(state.appSettings);
    emit(state.copyWith(activePresetData: ActivePresetData(preset: preset, isOverride: true, endTime: state.appSettings.presetOverrideEnd)));
    //_nativeNotifications.updatePresets();
  }

  PresetSetting presetSettingForGroup(ContactGroup group) {
    final currentSettings = state.activePresetData.preset.settings;
    //final currentSettings = state.appSettings.presetOverride.target?.settings;
    final setting = currentSettings.firstWhere(
            (setting) => setting.belongsToGroup(group),
        orElse: () => PresetSetting()
    );
    return setting;
  }

  Future<void> updateNotificationPolicyAccessPermissions(bool allowed) async {
    final newPermissions = await _nativeNotifications.hasPermissions();
    final changed = newPermissions != state.appSettings.hasNotificationPolicyAccessPermissions;

    if (changed) {
      state.appSettings.hasNotificationPolicyAccessPermissions = newPermissions;
      emit(state.copyWith(notificationPolicyAccessAllowedNonce: state.notificationPolicyAccessAllowedNonce + 1));
    }
  }

  Future<ActivePresetData> determineActivePreset() async {
    // Set the active preset data
    final activePresetData = await _database.determineActivePreset();
    emit(state.copyWith(activePresetData: activePresetData, activePresetNonce: state.activePresetNonce + 1));
    //// update presets with the native service
    //_nativeNotifications.updatePresets();
    return activePresetData;
  }

  void touchActivePreset() {
    emit(state.copyWith(activePresetNonce: state.activePresetNonce + 1));
  }

  static BlocProvider provider(AppSettingsCubit appSettingsCubit, {required Widget child}) => BlocProvider<AppSettingsCubit>.value(
    value: appSettingsCubit,
    child: Builder(
      builder: (context) {
        return child;
      }
    ),
  );

  static BlocBuilder builder(Widget Function(BuildContext, AppSettingsState) cubitBuilder) => BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: cubitBuilder
  );
}