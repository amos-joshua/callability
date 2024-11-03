import 'dart:async';
import 'dart:io';

import 'package:Callability/src/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'state.dart';
import '../devices/devices.dart';

class AuthCubit extends Cubit<AuthState> {
  final RuntimeParametersRepository runtimeParameters;
  final DevicesCubit devicesCubit;

  AuthCubit({required this.devicesCubit, required this.runtimeParameters}): super(const AuthState(authorized: false, identifier: ''));

  void signedIn(String identifier) {
    emit(state.copyWith(authorized: true, identifier: identifier));
  }

  void signedOut() => emit(state.copyWith(authorized: false, identifier: ''));
  
  Future<void> deleteUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Flogger.e('User uid is unexpectedly null when deleting user data', loggerName: 'DEVICES');
      return;
    }
    await FirebaseDatabase.instance.ref('/users/$uid').remove();
  }

  Future<void> processUserForAuthEvent(User? user) async {
    if (user == null) {
      signedOut();
    } else {
      final deviceRegistrationToken = await FirebaseMessaging.instance.getToken();
      final email = user.email;
      if (email == null) {
        Flogger.e('Cannot log in user with null email: $user', loggerName: 'LOGIN');
        return;
      }
      if (deviceRegistrationToken == null) {
        Flogger.e('Cannot log in user $user with null device registration token', loggerName: 'LOGIN');
      }
      final tokenEntry = {
        deviceRegistrationToken: '${Platform.operatingSystem} ${runtimeParameters.osVersion} ${runtimeParameters.phoneModel}'
      };
      final devicesPath = '${user.uid}/devices';
      FirebaseDatabase.instance.ref('users/$devicesPath').set(tokenEntry);
      signedIn(user.email ?? user.displayName ?? user.phoneNumber ?? '(Anonymous)');

      unawaited(devicesCubit.list());
    }
  }
}