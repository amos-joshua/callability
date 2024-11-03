import 'package:equatable/equatable.dart';
import '../../model/model.dart';

class AppSettingsState extends Equatable {
  final AppSettings appSettings;
  final ActivePresetData activePresetData;
  final int activePresetNonce;
  final int notificationPolicyAccessAllowedNonce;

  const AppSettingsState(this.appSettings, {required this.activePresetData, this.activePresetNonce = 0, this.notificationPolicyAccessAllowedNonce = 0});

  AppSettingsState copyWith({
    ActivePresetData? activePresetData,
    int? notificationPolicyAccessAllowedNonce,
    int? activePresetNonce,
  }) => AppSettingsState(appSettings,
      activePresetData: activePresetData ?? this.activePresetData,
      notificationPolicyAccessAllowedNonce: notificationPolicyAccessAllowedNonce ?? this.notificationPolicyAccessAllowedNonce,
      activePresetNonce: activePresetNonce ?? this.activePresetNonce
  );

  @override
  List<Object> get props => [appSettings, activePresetData.preset.id, activePresetNonce, notificationPolicyAccessAllowedNonce];
}