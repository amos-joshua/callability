import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'src/controller/controller.dart';
import 'src/storage/persistent_storage.dart';
import 'src/repositories/repositories.dart';
import 'src/app.dart';
import 'src/logging.dart';

void main() {
  initializeLogging();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
      App(
          controller: Controller(
            storage: PersistentStorage(),
            phoneContacts: NativePhoneContactsRepository()
          )
      )
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final send = IsolateNameServer.lookupPortByName('push-notification-payload-receiver-port');
  send?.send(message.data);
}