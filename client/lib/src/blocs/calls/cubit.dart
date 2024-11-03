import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grpc/grpc.dart';
import 'package:logging_flutter/logging_flutter.dart';

import '../../utils/native_notifications.dart';
import '../../model/model.dart';
import '../../repositories/repositories.dart';
import '../../../protobuf/service.pbgrpc.dart';
import 'state.dart';

class CallsCubit extends Cubit<CallsState> {
  final DBRepository database;

  CallsCubit({
    required this.database,
  }) : super(const CallsState());

  Future<void> list() async {
    final calls = await database.calls();
    emit(state.copyWith(calls: calls));
  }

  Future<void> clearCalls() async {
    await database.clearCalls();
    list();
  }
}

class CurrentCallCubit extends Cubit<CurrentCallState> {
  final AllContactsRepository allContacts;
  final DBRepository database;
  final CallsCubit callsCubit;
  final CallabilitySwitchboardClient grpcClient;
  final NativeNotifications nativeNotifications;
  CurrentCallCubit({
    required this.database,
    required this.callsCubit,
    required this.allContacts,
    required this.grpcClient,
    required this.nativeNotifications
  }): super(const CurrentCallState());

  StreamController? _outgoingCallStreamController;
  final incomingCallStreamController = StreamController<CallEvent>.broadcast();
  Stream<CallEvent> get incomingCallStream => incomingCallStreamController.stream;


  void clearContact() => emit(state.copyWith(noContact: true));

  void select(Contact contact) => emit(state.copyWith(
      contact: contact,
      email: contact.emails.isEmpty ? '' : contact.emails.first,
      urgency: CallUrgency.leisure,
      subject: ''
  ));

  void deselect() => emit(state.copyWith(noContact: true));

  void update({
    CallUrgency? urgency,
    String? subject,
    CallStatus? callStatus,
    String? callError,
    String? email,
    String? callUuid,
    bool clearContact = false
  }) => emit(state.copyWith(urgency: urgency, email: email, subject: subject, callStatus: callStatus, callError: callError, callUuid: callUuid, noContact: clearContact));

  void setEmail(String email) => emit(state.copyWith(email: email));

  Call? createCall({required bool outgoing}) {
    final contact = state.contact;
    //if (contact == null) return null;
    final call = Call(
      subject: state.subject,
      urgency: state.urgency,
      outgoing: outgoing,
      startTime: DateTime.now(),
      answered: false
    )..contact.target = contact;
    return call;
  }


  Future<void> incomingCallHangUp(HangUpFirebasePayload payload) async {
    try {
      Flogger.i('Sender hung up call ${payload.callUuid}');

      incomingCallStreamController.add(CallEvent.incomingCallHangUp);

      final group = await database.groupForContact(state.contact);
      final activePreset = await database.determineActivePreset();
      final setting = activePreset.preset.settingForGroup(group);
      final ringType = setting?.ringTypeFor(state.urgency) ?? RingType.vibrate;

      nativeNotifications.showMissedCallNotification(
          payload.callUuid,
          state.contact?.displayName ?? state.email,
          state.subject,
          state.urgency,
          ringType
      );
    }
    catch (exc, stackTrace) {
      Flogger.e('Error handling incoming call hang up for payload $payload: $exc', stackTrace: stackTrace, loggerName: 'CALL');
    }
  }

  Future<void> rejectCall() async {
    try {
      Flogger.i("Rejecting call '${state.callUuid}'");

      final callUuid = state.callUuid;
      if (callUuid.isEmpty) {
        Flogger.e('Call uuid is unexpectedly empty while rejecting call');
        return;
      }

      final clientTokenId =
          await FirebaseAuth.instance.currentUser?.getIdToken();
      if (clientTokenId == null) {
        Flogger.e(
            'Firebase client token id is unexpectedly null while rejecting call ${callUuid}');
      }

      final reject = ReceiverUpEvent(
          clientTokenId: clientTokenId ?? '(no-token)',
          callUuid: callUuid,
          reject: ReceiverReject());

      nativeNotifications.cancelCallNotification(state.callUuid);

      final response = await grpcClient.respondToCall(reject);

      if (response.hasError()) {
        Flogger.e(
            "Server returned an error when REJECTing call $callUuid: ${response.error.message} (${response.error.errorCode})");
        incomingCallStreamController.add(CallEvent.incomingCallHangUp);
      } else {
        incomingCallStreamController.add(CallEvent.incomingCallRejected);
      }
    }
    catch (exc, stackTrace) {
      Flogger.e("Error rejecting call '${state.callUuid}': $exc", stackTrace: stackTrace, loggerName: 'CALL');
    }
  }

  Future<void> acceptCall() async {
    try {
      Flogger.i("Accepting call '${state.callUuid}'");

      final callUuid = state.callUuid;
      if (callUuid.isEmpty) {
        Flogger.e('Call uuid is unexpectedly empty while accepting call');
        return;
      }

      final clientTokenId = await FirebaseAuth.instance.currentUser?.getIdToken();

      if (clientTokenId == null) {
        Flogger.e(
            'Firebase client token id is unexpectedly null while accepting call ${callUuid}');
      }

      final accept = ReceiverUpEvent(
          clientTokenId: clientTokenId ?? '(no-token)',
          callUuid: callUuid,
          accept: ReceiverAccept()
      );

      nativeNotifications.cancelCallNotification(state.callUuid);
      final response = await grpcClient.respondToCall(accept);

      if (response.hasError()) {
        Flogger.e(
            "Server returned an error when ACCEPTing call $callUuid: ${response
                .error.message} (${response.error.errorCode})");
        incomingCallStreamController.add(CallEvent.incomingCallHangUp);
      }
      else {
        incomingCallStreamController.add(CallEvent.incomingCallAccepted);
      }
    }
    catch (exc, stackTrace) {
      Flogger.e("Error accepting call '${state.callUuid}': $exc", stackTrace: stackTrace, loggerName: 'CALL');
    }
  }

  Future<void> receiveCall(IncomingCallFirebasePayload payload, {required bool isBackground}) async {
    try {
      Flogger.i("Receiving call from firebase payload: $payload");

      final contact = await allContacts.getByEmail(payload.email);
        if (contact != null) {
          select(contact);
        }

        final group = await database.groupForContact(contact);
        final activePreset = await database.determineActivePreset();
        final setting = activePreset.preset.settingForGroup(group);
        final ringType = setting?.ringTypeFor(payload.urgency) ?? RingType.vibrate;

        nativeNotifications.showCallNotification(
            payload.callUuid,
            contact?.displayName ?? payload.email,
            payload.subject,
            payload.urgency,
            ringType
        );

        update(
            urgency: payload.urgency,
            subject: payload.subject,
            email: payload.email,
            callUuid: payload.callUuid,
            clearContact: contact == null
        );

        final call = createCall(outgoing: false);
        if (call != null) {
          await database.saveCall(call);
          callsCubit.list();
        }

        incomingCallStreamController.add(CallEvent.incomingCallStart);
        final clientTokenId = await FirebaseAuth.instance.currentUser?.getIdToken();
        if (clientTokenId == null) {
          Flogger.e('Firebase client token id is unexpectedly null when receiving call ${payload.callUuid}');
        }

        final ack = ReceiverUpEvent(
            clientTokenId: clientTokenId ?? '(no-token)',
            callUuid: payload.callUuid,
            ack: ReceiverAck()
        );

        ReceiverDownEvent response;
        response = await grpcClient.respondToCall(ack).catchError((exc, stackTrace) {
          Flogger.e('Error awaiting response to call: $exc', stackTrace: stackTrace, loggerName: 'GRPC');
          return ReceiverDownEvent();
        });

        if (response.hasHangup()) {
          incomingCallStreamController.add(CallEvent.incomingCallHangUp);
        }
        else if (response.hasError()) {
          Flogger.e("Server returned an error when ACKing call ${payload.callUuid}: ${response.error.message} (${response.error.errorCode})");
          incomingCallStreamController.add(CallEvent.incomingCallHangUp);
        }
    }
    catch (exc, stackTrace) {
      Flogger.e("Error receiving call '${state.callUuid}': $exc", stackTrace: stackTrace, loggerName: 'CALL');
    }
  }

  Future<void> startCall(BuildContext context, Call call) async {
    try {
      Flogger.i("Starting call $call");

      await database.saveCall(call);
      callsCubit.list();

      update(callStatus: CallStatus.calling);

      final contact = call.contact.target;
      if (contact == null) {
        print('ERROR contact is unexpectedly null for initiated call');
        return;
      }

      if (context.mounted) {
        context.go('/calls/outgoing_call');
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OutgoingCallPage()));
      }

      final clientIdToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      final sendEvent = SenderUpEvent(
          callStart: SenderCallStart(
              urgency: call.urgency.index,
              subject: call.subject,
              receiverEmails: contact.emails,
              clientTokenId: clientIdToken ?? '(no token)'
          )
      );

      _outgoingCallStreamController?.close();
      final streamController = StreamController<SenderUpEvent>();
      _outgoingCallStreamController = streamController;
      streamController.add(sendEvent);
      //final requestStream = Stream<SenderUpEvent>.fromIterable([sendEvent]);

      var responseStream =  grpcClient.initiateCall(streamController.stream);
      await for (final response in responseStream) {
        if (response.hasAck()) {
          update(callStatus: CallStatus.ringing);
        }
        else if (response.hasAccept()) {
          update(callStatus: CallStatus.answered);
        }
        else if (response.hasRecipientNotRegistered()) {
          update(callStatus: CallStatus.recipientNotRegistered);
        }
        else if (response.hasReject()) {
          update(callStatus: CallStatus.rejected);
        }
        else if (response.hasNoAnswer()) {
          update(callStatus: CallStatus.notAnswered);
        }
        else if (response.hasError()) {
          update(callStatus: CallStatus.error, callError: response.error.message);
        }
      }
      _outgoingCallStreamController?.close();
      _outgoingCallStreamController = null;
    }
    on GrpcError catch (exc, stackTrace) {
      Flogger.e('GRPC Server error: $exc', stackTrace: stackTrace, loggerName: 'GRPC');
      if (exc.code == 14) {
        update(callStatus: CallStatus.error, callError: 'Server unavailable');
      }
    }
    catch (exc, stackTrace) {
      Flogger.e('GRPC Error: $exc', stackTrace: stackTrace, loggerName: 'GRPC');
    }
    //await channel.shutdown();

  }

  void outgoingCallHangUp() {
    _outgoingCallStreamController?.add(SenderUpEvent(hangUp: HangUp()));
  }

  void processFirebasePayload(Map<String, dynamic> data, {required bool fromBackground}) {
    FirebasePayload? payload;
    List<String> errors = [];
    try {
      (payload, errors) = FirebasePayload.parse(data);
      if (payload == null) {
        Flogger.e('Invalid incoming call, data payload $data has the following errors: $errors',
            loggerName: 'FIREBASE');
        return;
      }
    }
    catch (exc, stackTrace) {
      Flogger.e('Error parsing push notification payload: $exc', stackTrace: stackTrace, loggerName: 'FIREBASE');
    }

    try {
      switch (payload) {
        case IncomingCallFirebasePayload payload:
          receiveCall(payload, isBackground: fromBackground);
        case HangUpFirebasePayload payload :
          incomingCallHangUp(payload);
        default:
          Flogger.e('Invalid incoming call, data payload $data has the following errors: $errors',
              loggerName: 'FIREBASE');
      }
    }
    catch (exc, stackTrace) {
      Flogger.e('Error handling push notification payload: $exc', stackTrace: stackTrace, loggerName: 'FIREBASE');
    }
  }
}