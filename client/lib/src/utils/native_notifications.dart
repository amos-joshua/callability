import 'package:flutter/services.dart';
import '../repositories/db_repository.dart';
import '../model/model.dart';

class NativeNotifications {
  final methodChannel = const MethodChannel('net.swiftllama.callquery/notifications');
  final DBRepository database;

  const NativeNotifications({required this.database});

  Future<bool> requestPermissions() async {
    return await methodChannel.invokeMethod<bool>('requestAccessNotificationPolicyPermissions') ?? false;
  }

  Future<bool> hasPermissions() async {
    return await methodChannel.invokeMethod<bool>('hasAccessNotificationPolicyPermissions') ?? false;
  }

  Future<void> showCallNotification(String callUuid, String displayName, String subject, CallUrgency urgency, RingType ringType) async {
    return await methodChannel.invokeMethod('showCallNotification', [
      callUuid,
      displayName,
      subject,
      urgency.index,
      ringType.index
    ]);
  }


  Future<void> cancelCallNotification(String callUuid) async {
    return await methodChannel.invokeMethod('cancelCallNotification', [
      callUuid,
      '',
      '',
      0,
      0
    ]);
  }

  Future<void> showMissedCallNotification(String callUuid, String displayName, String subject, CallUrgency urgency, RingType ringType) async {
    return await methodChannel.invokeMethod('showMissedCallNotification', [
      callUuid,
      displayName,
      subject,
      urgency.index,
      ringType.index
    ]);
  }

  /*
  Future<void> updatePresets() async {
    final map = await _presetsMap();
    await methodChannel.invokeMethod('updatePresets', map);
  }

  Future<Map> _presetsMap() async {
    final groups = await database.groups('');
    final presets = await database.presets();
    final appSettings = database.appSettings();

    final presetMaps = presets.map((preset) => preset.asMap()).toList();
    final groupMaps = groups.map((group) => group.asMap()).toList();

    final presetOverride = appSettings.presetOverride.target;

    return {
      'groups': groupMaps,
      'presets': presetMaps,
      'presetOverride': presetOverride == null ? null : {
        'name': presetOverride.name,
        'startTime': appSettings.presetOverrideStart.toIso8601String(),
        'endTime': appSettings.presetOverrideEnd.toIso8601String(),
      }
    };
  }*/
}