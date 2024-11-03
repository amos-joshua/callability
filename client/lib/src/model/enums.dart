import 'package:flutter/material.dart';
import '../utils/string_utils.dart';

enum CallUrgency {
  leisure, important, urgent
}

extension CallUrgencyUtils on CallUrgency {
  Color color() => switch(this) {
    CallUrgency.urgent => Colors.red.shade300.withOpacity(0.9),
    CallUrgency.important => Colors.yellow.shade800.withOpacity(0.8),
    CallUrgency.leisure => Colors.green.withOpacity(0.8)
  };


  String label() => toString().replaceFirst('CallUrgency.', '');

  String adjectiveLabel() => switch(this) {
    CallUrgency.urgent => 'urgent',
    CallUrgency.important => 'important',
    CallUrgency.leisure => 'leisurely'
  };
}

enum Init {
  storage, contactsPermission, loadContacts,
  loadPaths, loadPackageInfo, requestPermissions,
  ensureDefaultsExist, createAppSettingsCubit,
  firstTimeInit, initBackgroundService, firebaseAuth,
  intentCallbacksListener
}

extension InitUtils on Init {
  String label() => toString().replaceFirst('Init.', '');
}

enum RingType {
  silent, vibrate, ring
}

extension RingTypeUtils on RingType {
  String get label => toString().replaceFirst('RingType.', '');

  IconData get icon => switch(this) {
    RingType.silent => Icons.volume_off,
    RingType.vibrate => Icons.vibration,
    RingType.ring => Icons.volume_up
  };

  RingType get nextRingType => switch(this) {
    RingType.silent => RingType.vibrate,
    RingType.vibrate => RingType.ring,
    RingType.ring => RingType.silent
  };
}

enum Days {
  sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

extension DaysUtils on Days {
  String label() => toString().replaceFirst('Days.', '').capitalized;
  String shortLabel() => label().substring(0, 2);
}

enum CallStatus {
  composing, calling, ringing, answered, rejected, notAnswered, recipientNotRegistered, error
}

extension CallStatusUtils on CallStatus {
  String label() => toString().replaceFirst('CallStatus.', '');
}
