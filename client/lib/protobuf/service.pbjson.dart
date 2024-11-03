//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use errorCodeDescriptor instead')
const ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'clientAuthenticationFailed', '2': 0},
    {'1': 'serverError', '2': 1},
    {'1': 'noSuchSession', '2': 2},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode(
    'CglFcnJvckNvZGUSHgoaY2xpZW50QXV0aGVudGljYXRpb25GYWlsZWQQABIPCgtzZXJ2ZXJFcn'
    'JvchABEhEKDW5vU3VjaFNlc3Npb24QAg==');

@$core.Deprecated('Use serverStatusInquiryDescriptor instead')
const ServerStatusInquiry$json = {
  '1': 'ServerStatusInquiry',
};

/// Descriptor for `ServerStatusInquiry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverStatusInquiryDescriptor = $convert.base64Decode(
    'ChNTZXJ2ZXJTdGF0dXNJbnF1aXJ5');

@$core.Deprecated('Use serverStatusDescriptor instead')
const ServerStatus$json = {
  '1': 'ServerStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `ServerStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverStatusDescriptor = $convert.base64Decode(
    'CgxTZXJ2ZXJTdGF0dXMSFgoGc3RhdHVzGAEgASgJUgZzdGF0dXM=');

@$core.Deprecated('Use receiverUpEventDescriptor instead')
const ReceiverUpEvent$json = {
  '1': 'ReceiverUpEvent',
  '2': [
    {'1': 'client_token_id', '3': 1, '4': 1, '5': 9, '10': 'clientTokenId'},
    {'1': 'call_uuid', '3': 2, '4': 1, '5': 9, '10': 'callUuid'},
    {'1': 'ack', '3': 3, '4': 1, '5': 11, '6': '.ReceiverAck', '9': 0, '10': 'ack'},
    {'1': 'accept', '3': 4, '4': 1, '5': 11, '6': '.ReceiverAccept', '9': 0, '10': 'accept'},
    {'1': 'reject', '3': 5, '4': 1, '5': 11, '6': '.ReceiverReject', '9': 0, '10': 'reject'},
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ReceiverUpEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiverUpEventDescriptor = $convert.base64Decode(
    'Cg9SZWNlaXZlclVwRXZlbnQSJgoPY2xpZW50X3Rva2VuX2lkGAEgASgJUg1jbGllbnRUb2tlbk'
    'lkEhsKCWNhbGxfdXVpZBgCIAEoCVIIY2FsbFV1aWQSIAoDYWNrGAMgASgLMgwuUmVjZWl2ZXJB'
    'Y2tIAFIDYWNrEikKBmFjY2VwdBgEIAEoCzIPLlJlY2VpdmVyQWNjZXB0SABSBmFjY2VwdBIpCg'
    'ZyZWplY3QYBSABKAsyDy5SZWNlaXZlclJlamVjdEgAUgZyZWplY3RCBwoFZXZlbnQ=');

@$core.Deprecated('Use receiverDownEventDescriptor instead')
const ReceiverDownEvent$json = {
  '1': 'ReceiverDownEvent',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.Error', '9': 0, '10': 'error'},
    {'1': 'hangup', '3': 2, '4': 1, '5': 11, '6': '.HangUp', '9': 0, '10': 'hangup'},
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ReceiverDownEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiverDownEventDescriptor = $convert.base64Decode(
    'ChFSZWNlaXZlckRvd25FdmVudBIeCgVlcnJvchgBIAEoCzIGLkVycm9ySABSBWVycm9yEiEKBm'
    'hhbmd1cBgCIAEoCzIHLkhhbmdVcEgAUgZoYW5ndXBCBwoFZXZlbnQ=');

@$core.Deprecated('Use senderCallStartDescriptor instead')
const SenderCallStart$json = {
  '1': 'SenderCallStart',
  '2': [
    {'1': 'client_token_id', '3': 1, '4': 1, '5': 9, '10': 'clientTokenId'},
    {'1': 'receiver_emails', '3': 2, '4': 3, '5': 9, '10': 'receiverEmails'},
    {'1': 'urgency', '3': 3, '4': 1, '5': 13, '10': 'urgency'},
    {'1': 'subject', '3': 4, '4': 1, '5': 9, '10': 'subject'},
  ],
};

/// Descriptor for `SenderCallStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderCallStartDescriptor = $convert.base64Decode(
    'Cg9TZW5kZXJDYWxsU3RhcnQSJgoPY2xpZW50X3Rva2VuX2lkGAEgASgJUg1jbGllbnRUb2tlbk'
    'lkEicKD3JlY2VpdmVyX2VtYWlscxgCIAMoCVIOcmVjZWl2ZXJFbWFpbHMSGAoHdXJnZW5jeRgD'
    'IAEoDVIHdXJnZW5jeRIYCgdzdWJqZWN0GAQgASgJUgdzdWJqZWN0');

@$core.Deprecated('Use hangUpDescriptor instead')
const HangUp$json = {
  '1': 'HangUp',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `HangUp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hangUpDescriptor = $convert.base64Decode(
    'CgZIYW5nVXASFgoGcmVhc29uGAEgASgJUgZyZWFzb24=');

@$core.Deprecated('Use receiverAckDescriptor instead')
const ReceiverAck$json = {
  '1': 'ReceiverAck',
};

/// Descriptor for `ReceiverAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiverAckDescriptor = $convert.base64Decode(
    'CgtSZWNlaXZlckFjaw==');

@$core.Deprecated('Use receiverAcceptDescriptor instead')
const ReceiverAccept$json = {
  '1': 'ReceiverAccept',
};

/// Descriptor for `ReceiverAccept`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiverAcceptDescriptor = $convert.base64Decode(
    'Cg5SZWNlaXZlckFjY2VwdA==');

@$core.Deprecated('Use receiverRejectDescriptor instead')
const ReceiverReject$json = {
  '1': 'ReceiverReject',
};

/// Descriptor for `ReceiverReject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiverRejectDescriptor = $convert.base64Decode(
    'Cg5SZWNlaXZlclJlamVjdA==');

@$core.Deprecated('Use recipientNotRegisteredDescriptor instead')
const RecipientNotRegistered$json = {
  '1': 'RecipientNotRegistered',
};

/// Descriptor for `RecipientNotRegistered`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipientNotRegisteredDescriptor = $convert.base64Decode(
    'ChZSZWNpcGllbnROb3RSZWdpc3RlcmVk');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'errorCode', '3': 1, '4': 1, '5': 14, '6': '.ErrorCode', '10': 'errorCode'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchIoCgllcnJvckNvZGUYASABKA4yCi5FcnJvckNvZGVSCWVycm9yQ29kZRIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use senderUpEventDescriptor instead')
const SenderUpEvent$json = {
  '1': 'SenderUpEvent',
  '2': [
    {'1': 'callStart', '3': 1, '4': 1, '5': 11, '6': '.SenderCallStart', '9': 0, '10': 'callStart'},
    {'1': 'hangUp', '3': 2, '4': 1, '5': 11, '6': '.HangUp', '9': 0, '10': 'hangUp'},
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `SenderUpEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderUpEventDescriptor = $convert.base64Decode(
    'Cg1TZW5kZXJVcEV2ZW50EjAKCWNhbGxTdGFydBgBIAEoCzIQLlNlbmRlckNhbGxTdGFydEgAUg'
    'ljYWxsU3RhcnQSIQoGaGFuZ1VwGAIgASgLMgcuSGFuZ1VwSABSBmhhbmdVcEIHCgVldmVudA==');

@$core.Deprecated('Use noAnswerDescriptor instead')
const NoAnswer$json = {
  '1': 'NoAnswer',
};

/// Descriptor for `NoAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noAnswerDescriptor = $convert.base64Decode(
    'CghOb0Fuc3dlcg==');

@$core.Deprecated('Use senderDownEventDescriptor instead')
const SenderDownEvent$json = {
  '1': 'SenderDownEvent',
  '2': [
    {'1': 'ack', '3': 1, '4': 1, '5': 11, '6': '.ReceiverAck', '9': 0, '10': 'ack'},
    {'1': 'accept', '3': 2, '4': 1, '5': 11, '6': '.ReceiverAccept', '9': 0, '10': 'accept'},
    {'1': 'reject', '3': 3, '4': 1, '5': 11, '6': '.ReceiverReject', '9': 0, '10': 'reject'},
    {'1': 'noAnswer', '3': 4, '4': 1, '5': 11, '6': '.NoAnswer', '9': 0, '10': 'noAnswer'},
    {'1': 'recipientNotRegistered', '3': 5, '4': 1, '5': 11, '6': '.RecipientNotRegistered', '9': 0, '10': 'recipientNotRegistered'},
    {'1': 'error', '3': 6, '4': 1, '5': 11, '6': '.Error', '9': 0, '10': 'error'},
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `SenderDownEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderDownEventDescriptor = $convert.base64Decode(
    'Cg9TZW5kZXJEb3duRXZlbnQSIAoDYWNrGAEgASgLMgwuUmVjZWl2ZXJBY2tIAFIDYWNrEikKBm'
    'FjY2VwdBgCIAEoCzIPLlJlY2VpdmVyQWNjZXB0SABSBmFjY2VwdBIpCgZyZWplY3QYAyABKAsy'
    'Dy5SZWNlaXZlclJlamVjdEgAUgZyZWplY3QSJwoIbm9BbnN3ZXIYBCABKAsyCS5Ob0Fuc3dlck'
    'gAUghub0Fuc3dlchJRChZyZWNpcGllbnROb3RSZWdpc3RlcmVkGAUgASgLMhcuUmVjaXBpZW50'
    'Tm90UmVnaXN0ZXJlZEgAUhZyZWNpcGllbnROb3RSZWdpc3RlcmVkEh4KBWVycm9yGAYgASgLMg'
    'YuRXJyb3JIAFIFZXJyb3JCBwoFZXZlbnQ=');

