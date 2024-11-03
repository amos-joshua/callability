
import 'dart:isolate';
import 'package:grpc/grpc.dart';

import '../../protobuf/service.pbgrpc.dart';
import '../repositories/repositories.dart';
import '../storage/storage.dart';
import '../utils/native_notifications.dart';
import '../blocs/app_settings/app_settings.dart';
import '../blocs/auth/auth.dart';
import '../blocs/calls/calls.dart';
import '../blocs/devices/devices.dart';


import '../blocs/app_init/cubit.dart';
import '../blocs/groups/cubit.dart';
import '../blocs/presets/cubit.dart';

export 'app_init.dart';

class Controller {
  Controller({required this.storage, required this.phoneContacts});

  final Storage storage;
  final PhoneContactsRepository phoneContacts;
  final devices = DevicesCubit();
  final pushNotificationReceiverPort = ReceivePort();
  final runtimeParameters = RuntimeParametersRepository();
  final appInit = AppInitCubit();
  late final database = DBRepository(storage);
  late final nativeNotifications = NativeNotifications(database: database);
  late final groups = GroupsCubit(database: database, presetsCubit: presets);
  late final presets = PresetsCubit(database: database, nativeNotifications: nativeNotifications);
  late final allContacts = AllContactsRepository(storage);
  late final AppSettingsCubit appSettingsCubit;
  late final auth = AuthCubit(devicesCubit: devices, runtimeParameters: runtimeParameters);

  late final calls = CallsCubit(
    database: database,
  );
  late final currentCall = CurrentCallCubit(
      database: database,
      callsCubit: calls,
      grpcClient: grpcClient,
      allContacts: allContacts,
      nativeNotifications: nativeNotifications
  );

  final grpcClient = CallabilitySwitchboardClient(
    /*
    ClientChannel(
      '192.168.1.28',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure()
      ),
    ),
     */
    ClientChannel(
      'dublin.swiftllama.net',
      port: 443,
      options: const ChannelOptions(
        credentials: ChannelCredentials.secure()
      ),
    )
  );
}