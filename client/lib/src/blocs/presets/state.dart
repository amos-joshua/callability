import 'package:equatable/equatable.dart';

import '../../model/model.dart';

class PresetsState extends Equatable {
  final List<Preset> presets;
  final bool loading;

  const PresetsState({
    this.presets = const [],
    this.loading = true,
  });

  PresetsState copyWith({
    List<Preset>? presets,
    bool? loading,
    Preset? selectedPreset,
  }) =>
      PresetsState(
          presets: presets ?? this.presets, loading: loading ?? this.loading);

  @override
  List<Object> get props => [presets, loading];
}
 
class PresetState extends Equatable {
  final Preset preset;
  final int nameNonce;
  final int settingsNonce;
  final int schedulesNonce;
  
  const PresetState({
    required this.preset,
    this.nameNonce = 0,
    this.settingsNonce = 0,
    this.schedulesNonce = 0
  });
  
  PresetState copyWith({
    int? nameNonce,
    int? settingsNonce,
    int? schedulesNonce
  }) => PresetState(preset: preset, nameNonce: nameNonce ?? this.nameNonce, settingsNonce: settingsNonce ??  this.settingsNonce, schedulesNonce: schedulesNonce ?? this.schedulesNonce);
  
  @override
  List<Object> get props => [preset, nameNonce, settingsNonce, schedulesNonce];
}

class PresetSettingState extends Equatable {
  final PresetSetting presetSetting;
  final int ringTypesNonce;

  const PresetSettingState(this.presetSetting, {
    required this.ringTypesNonce
  });

  PresetSettingState copyWith({
    int? sliderIndex,
    int? ringTypesNonce,
  }) => PresetSettingState(presetSetting, ringTypesNonce: ringTypesNonce ?? this.ringTypesNonce);
  
  @override
  List<Object?> get props => [presetSetting, ringTypesNonce];
}