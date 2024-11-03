import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'state.dart';

class DevicesCubit extends Cubit<DevicesState> {

  DevicesCubit(): super(const DevicesState(devices: [], loading: true));

  Future<void> updateIfStale() async {
    final lastUpdated = state.lastUpdated;
    if (lastUpdated == null) {
      list();
    }
    else {
      final delta = DateTime.now().difference(lastUpdated);
      if (delta.inSeconds > 60) {
        list();
      }
    }
  }

  Future<void> list() async {
    emit(state.copyWith(loading: true));
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Flogger.e('User uid is unexpectedly null when retrieving devices from firebase', loggerName: 'DEVICES');
      return;
    }
    final devicesSnapshot = (await FirebaseDatabase.instance.ref('/users/$uid/devices').get()).value;
    if (devicesSnapshot == null) {
      return;
    }
    final devicesMap = devicesSnapshot as Map;
    final devices = devicesMap.values.map((value) => '$value').toList();
    emit(state.copyWith(loading: false, devices: devices, lastUpdated: DateTime.now()));
  }
}