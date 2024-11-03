//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('CallabilitySwitchboard')
class CallabilitySwitchboardClient extends $grpc.Client {
  static final _$initiateCall = $grpc.ClientMethod<$0.SenderUpEvent, $0.SenderDownEvent>(
      '/CallabilitySwitchboard/InitiateCall',
      ($0.SenderUpEvent value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SenderDownEvent.fromBuffer(value));
  static final _$respondToCall = $grpc.ClientMethod<$0.ReceiverUpEvent, $0.ReceiverDownEvent>(
      '/CallabilitySwitchboard/RespondToCall',
      ($0.ReceiverUpEvent value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ReceiverDownEvent.fromBuffer(value));
  static final _$health = $grpc.ClientMethod<$0.ServerStatusInquiry, $0.ServerStatus>(
      '/CallabilitySwitchboard/Health',
      ($0.ServerStatusInquiry value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ServerStatus.fromBuffer(value));

  CallabilitySwitchboardClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.SenderDownEvent> initiateCall($async.Stream<$0.SenderUpEvent> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$initiateCall, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReceiverDownEvent> respondToCall($0.ReceiverUpEvent request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$respondToCall, request, options: options);
  }

  $grpc.ResponseFuture<$0.ServerStatus> health($0.ServerStatusInquiry request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$health, request, options: options);
  }
}

@$pb.GrpcServiceName('CallabilitySwitchboard')
abstract class CallabilitySwitchboardServiceBase extends $grpc.Service {
  $core.String get $name => 'CallabilitySwitchboard';

  CallabilitySwitchboardServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SenderUpEvent, $0.SenderDownEvent>(
        'InitiateCall',
        initiateCall,
        true,
        true,
        ($core.List<$core.int> value) => $0.SenderUpEvent.fromBuffer(value),
        ($0.SenderDownEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReceiverUpEvent, $0.ReceiverDownEvent>(
        'RespondToCall',
        respondToCall_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ReceiverUpEvent.fromBuffer(value),
        ($0.ReceiverDownEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ServerStatusInquiry, $0.ServerStatus>(
        'Health',
        health_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ServerStatusInquiry.fromBuffer(value),
        ($0.ServerStatus value) => value.writeToBuffer()));
  }

  $async.Future<$0.ReceiverDownEvent> respondToCall_Pre($grpc.ServiceCall call, $async.Future<$0.ReceiverUpEvent> request) async {
    return respondToCall(call, await request);
  }

  $async.Future<$0.ServerStatus> health_Pre($grpc.ServiceCall call, $async.Future<$0.ServerStatusInquiry> request) async {
    return health(call, await request);
  }

  $async.Stream<$0.SenderDownEvent> initiateCall($grpc.ServiceCall call, $async.Stream<$0.SenderUpEvent> request);
  $async.Future<$0.ReceiverDownEvent> respondToCall($grpc.ServiceCall call, $0.ReceiverUpEvent request);
  $async.Future<$0.ServerStatus> health($grpc.ServiceCall call, $0.ServerStatusInquiry request);
}
