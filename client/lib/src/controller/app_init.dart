import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../blocs/app_settings/cubit.dart';
import '../model/model.dart';
import '../../firebase_options.dart';
import 'controller.dart';

extension AppInit on Controller {
  
  Future<void> initialize() async {
    await initPhase(Init.loadPackageInfo, loadPackageInfo);
    await initPhase(Init.firebaseAuth, firebaseAuth);
    await initPhase(Init.loadPaths, loadPaths);
    await initPhase(Init.storage, () => storage.initialize(runtimeParameters.supportDirectory));
    await initPhase(Init.ensureDefaultsExist, ensureDefaultsExist);
    await initPhase(Init.contactsPermission, phoneContacts.requestContactsPermission);
    await initPhase(Init.requestPermissions, requestPermissions);
    await initPhase(Init.loadContacts, loadModelFromStorage);
    await initPhase(Init.createAppSettingsCubit, createAppSettingsCubit);
    await initPhase(Init.firstTimeInit, firstTimeInit);
    await initPhase(Init.intentCallbacksListener, intentCallbackListener);
    appInit.finish();
  }

  Future<void> loadPaths() async {
    final path = (await getApplicationSupportDirectory()).path;
    Flogger.i('Loaded app support directory: "$path"');
    runtimeParameters.supportDirectory = path;
  }

  Future<void> firebaseAuth() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );


    IsolateNameServer.registerPortWithName(pushNotificationReceiverPort.sendPort, 'push-notification-payload-receiver-port');
    pushNotificationReceiverPort.listen((dynamic data) {
      currentCall.processFirebasePayload(data, fromBackground: true);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      currentCall.processFirebasePayload(message.data, fromBackground: false);
    });

    FirebaseAuth.instance.authStateChanges().listen(
      auth.processUserForAuthEvent
    );
  }

  Future<void> loadModelFromStorage() async {
    await refreshContactsFromContactBook();
    phoneContacts.onContactsChanged(refreshContactsFromContactBook);
    await groups.list('');
    await presets.list();
    await calls.list();
  }

  Future<void> refreshContactsFromContactBook() async {
    final contacts = await phoneContacts.getAllContacts();
    await allContacts.refreshContacts(contacts);
  }

  Future<void> ensureDefaultsExist() async {
    await database.defaultPreset();
  }

  Future<void> initPhase(Init phase, Future<void> Function() phaseExecution) async {
    try {
      await phaseExecution();
    }
    catch (exc, stackTrace) {
      Flogger.e('${phase.label()} error: $exc', stackTrace: stackTrace, loggerName: 'INIT');
      appInit.addInitError(phase, '$exc');
    }
  }

  Future<void> loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    runtimeParameters.version = packageInfo.version;
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      runtimeParameters.phoneModel = '${deviceInfo.brand} (${deviceInfo.model})';
      runtimeParameters.osVersion = deviceInfo.version.release;
    }
    else {
      Flogger.e('Skipping runtime parameter init for phone model and os version on unexpected platform ${Platform.operatingSystem}');
    }
  }

  Future<void> requestPermissions() async {
    final settings = database.appSettings();
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
    settings.hasReceivePushNotificationsPermissions = [AuthorizationStatus.authorized, AuthorizationStatus.provisional].contains(notificationSettings.authorizationStatus);
    settings.hasNotificationPolicyAccessPermissions = await nativeNotifications.hasPermissions();
    database.saveAppSettings(settings);
  }

  Future<void> createAppSettingsCubit() async {
    final activePresetData = await database.determineActivePreset();
    appSettingsCubit = AppSettingsCubit(
      database: database,
      nativeNotifications: nativeNotifications,
      activePresetData: activePresetData
    );
  }
  
  Future<void> firstTimeInit() async {
    final family = ContactGroup(
      name: 'Family',
      catchAll: false,
    );
    final friends = ContactGroup(
        name: 'Friends',
        catchAll: false
    );
    final others = ContactGroup(
        name: ContactGroup.catchAllGroupName,
        catchAll: true
    );

    if (appSettingsCubit.state.appSettings.performedFirstTimeInit) {
      // Verify that we have an "Others" group
      final existingOthers = (await database.groups('')).where((group) => group.catchAll).firstOrNull;
      if (existingOthers == null) {
        await groups.save(others);
      }
      return;
    }

    final allPresets = await database.presets();
    await groups.save(family);
    await groups.save(friends);
    await groups.save(others);

    
    if (allPresets.length <= 1) {
      final nightSchedule = Schedule(
          days: Schedule.everyDay,
          startTime: const TimeOfDay(hour: 21, minute: 00),
          endTime: const TimeOfDay(hour: 08, minute: 00)
      );

      final workdaysSchedule = Schedule(
          days: Schedule.weekdays,
          startTime: const TimeOfDay(hour: 9, minute: 00),
          endTime: const TimeOfDay(hour: 17, minute: 00)
      );

      await presets.save(Preset(
          name: 'Night'
      )..schedules.add(nightSchedule)
       ..settings.addAll([
         PresetSetting.forGroup(family, RingType.silent, RingType.silent, RingType.ring),
         PresetSetting.forGroup(friends, RingType.silent, RingType.silent, RingType.ring),
         PresetSetting.forGroup(others, RingType.silent, RingType.silent, RingType.silent),
       ])
      );

      await presets.save(Preset(
          name: 'Work'
      )..schedules.add(workdaysSchedule)
        ..settings.addAll([
          PresetSetting.forGroup(family, RingType.silent, RingType.vibrate, RingType.ring),
          PresetSetting.forGroup(friends, RingType.silent, RingType.vibrate, RingType.ring),
          PresetSetting.forGroup(others, RingType.silent, RingType.silent, RingType.silent),
        ])
      );

      await presets.save(Preset(
          name: 'Busy'
        )..settings.addAll([
          PresetSetting.forGroup(family, RingType.silent, RingType.silent, RingType.vibrate),
          PresetSetting.forGroup(friends, RingType.silent, RingType.silent, RingType.vibrate),
          PresetSetting.forGroup(others, RingType.silent, RingType.silent, RingType.silent),
        ])
      );

      appSettingsCubit.state.appSettings.currentSchemaVersion = runtimeParameters.version;
      appSettingsCubit.state.appSettings.performedFirstTimeInit = true;
      await database.saveAppSettings(appSettingsCubit.state.appSettings);

      appSettingsCubit.determineActivePreset();
    }
  }

  Future<void> intentCallbackListener() async {
    nativeNotifications.methodChannel.setMethodCallHandler((methodCall) async {
      try {
        if (methodCall.method == 'callAction') {
          final arguments = methodCall.arguments as List;
          final callAction = arguments[0];
          final callUuid = arguments[1];
          if (callUuid != currentCall.state.callUuid) {
            Flogger.w('received event for call "$callUuid" which is different from current call uuid "${currentCall.state.callUuid}"', loggerName: 'INTENTS');
          }
          if (callAction == 'accept') {
            currentCall.acceptCall();
          }
          else if (callAction == 'decline') {
            currentCall.rejectCall();
          }

        }
      }
      catch (exc, stackTrace){
        Flogger.e('could not handle method $methodCall: $exc\n$stackTrace', loggerName: 'INTENT');
      }
    });
  }
}