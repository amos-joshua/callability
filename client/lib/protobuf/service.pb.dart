//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pbenum.dart';

export 'service.pbenum.dart';

class ServerStatusInquiry extends $pb.GeneratedMessage {
  factory ServerStatusInquiry() => create();
  ServerStatusInquiry._() : super();
  factory ServerStatusInquiry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerStatusInquiry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerStatusInquiry', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerStatusInquiry clone() => ServerStatusInquiry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerStatusInquiry copyWith(void Function(ServerStatusInquiry) updates) => super.copyWith((message) => updates(message as ServerStatusInquiry)) as ServerStatusInquiry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerStatusInquiry create() => ServerStatusInquiry._();
  ServerStatusInquiry createEmptyInstance() => create();
  static $pb.PbList<ServerStatusInquiry> createRepeated() => $pb.PbList<ServerStatusInquiry>();
  @$core.pragma('dart2js:noInline')
  static ServerStatusInquiry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerStatusInquiry>(create);
  static ServerStatusInquiry? _defaultInstance;
}

class ServerStatus extends $pb.GeneratedMessage {
  factory ServerStatus({
    $core.String? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  ServerStatus._() : super();
  factory ServerStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerStatus', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerStatus clone() => ServerStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerStatus copyWith(void Function(ServerStatus) updates) => super.copyWith((message) => updates(message as ServerStatus)) as ServerStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerStatus create() => ServerStatus._();
  ServerStatus createEmptyInstance() => create();
  static $pb.PbList<ServerStatus> createRepeated() => $pb.PbList<ServerStatus>();
  @$core.pragma('dart2js:noInline')
  static ServerStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerStatus>(create);
  static ServerStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

enum ReceiverUpEvent_Event {
  ack, 
  accept, 
  reject, 
  notSet
}

class ReceiverUpEvent extends $pb.GeneratedMessage {
  factory ReceiverUpEvent({
    $core.String? clientTokenId,
    $core.String? callUuid,
    ReceiverAck? ack,
    ReceiverAccept? accept,
    ReceiverReject? reject,
  }) {
    final $result = create();
    if (clientTokenId != null) {
      $result.clientTokenId = clientTokenId;
    }
    if (callUuid != null) {
      $result.callUuid = callUuid;
    }
    if (ack != null) {
      $result.ack = ack;
    }
    if (accept != null) {
      $result.accept = accept;
    }
    if (reject != null) {
      $result.reject = reject;
    }
    return $result;
  }
  ReceiverUpEvent._() : super();
  factory ReceiverUpEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverUpEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ReceiverUpEvent_Event> _ReceiverUpEvent_EventByTag = {
    3 : ReceiverUpEvent_Event.ack,
    4 : ReceiverUpEvent_Event.accept,
    5 : ReceiverUpEvent_Event.reject,
    0 : ReceiverUpEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiverUpEvent', createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'clientTokenId')
    ..aOS(2, _omitFieldNames ? '' : 'callUuid')
    ..aOM<ReceiverAck>(3, _omitFieldNames ? '' : 'ack', subBuilder: ReceiverAck.create)
    ..aOM<ReceiverAccept>(4, _omitFieldNames ? '' : 'accept', subBuilder: ReceiverAccept.create)
    ..aOM<ReceiverReject>(5, _omitFieldNames ? '' : 'reject', subBuilder: ReceiverReject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverUpEvent clone() => ReceiverUpEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverUpEvent copyWith(void Function(ReceiverUpEvent) updates) => super.copyWith((message) => updates(message as ReceiverUpEvent)) as ReceiverUpEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiverUpEvent create() => ReceiverUpEvent._();
  ReceiverUpEvent createEmptyInstance() => create();
  static $pb.PbList<ReceiverUpEvent> createRepeated() => $pb.PbList<ReceiverUpEvent>();
  @$core.pragma('dart2js:noInline')
  static ReceiverUpEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiverUpEvent>(create);
  static ReceiverUpEvent? _defaultInstance;

  ReceiverUpEvent_Event whichEvent() => _ReceiverUpEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get clientTokenId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientTokenId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientTokenId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientTokenId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set callUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallUuid() => clearField(2);

  @$pb.TagNumber(3)
  ReceiverAck get ack => $_getN(2);
  @$pb.TagNumber(3)
  set ack(ReceiverAck v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAck() => $_has(2);
  @$pb.TagNumber(3)
  void clearAck() => clearField(3);
  @$pb.TagNumber(3)
  ReceiverAck ensureAck() => $_ensure(2);

  @$pb.TagNumber(4)
  ReceiverAccept get accept => $_getN(3);
  @$pb.TagNumber(4)
  set accept(ReceiverAccept v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAccept() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccept() => clearField(4);
  @$pb.TagNumber(4)
  ReceiverAccept ensureAccept() => $_ensure(3);

  @$pb.TagNumber(5)
  ReceiverReject get reject => $_getN(4);
  @$pb.TagNumber(5)
  set reject(ReceiverReject v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasReject() => $_has(4);
  @$pb.TagNumber(5)
  void clearReject() => clearField(5);
  @$pb.TagNumber(5)
  ReceiverReject ensureReject() => $_ensure(4);
}

enum ReceiverDownEvent_Event {
  error, 
  hangup, 
  notSet
}

class ReceiverDownEvent extends $pb.GeneratedMessage {
  factory ReceiverDownEvent({
    Error? error,
    HangUp? hangup,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (hangup != null) {
      $result.hangup = hangup;
    }
    return $result;
  }
  ReceiverDownEvent._() : super();
  factory ReceiverDownEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverDownEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ReceiverDownEvent_Event> _ReceiverDownEvent_EventByTag = {
    1 : ReceiverDownEvent_Event.error,
    2 : ReceiverDownEvent_Event.hangup,
    0 : ReceiverDownEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiverDownEvent', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<Error>(1, _omitFieldNames ? '' : 'error', subBuilder: Error.create)
    ..aOM<HangUp>(2, _omitFieldNames ? '' : 'hangup', subBuilder: HangUp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverDownEvent clone() => ReceiverDownEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverDownEvent copyWith(void Function(ReceiverDownEvent) updates) => super.copyWith((message) => updates(message as ReceiverDownEvent)) as ReceiverDownEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiverDownEvent create() => ReceiverDownEvent._();
  ReceiverDownEvent createEmptyInstance() => create();
  static $pb.PbList<ReceiverDownEvent> createRepeated() => $pb.PbList<ReceiverDownEvent>();
  @$core.pragma('dart2js:noInline')
  static ReceiverDownEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiverDownEvent>(create);
  static ReceiverDownEvent? _defaultInstance;

  ReceiverDownEvent_Event whichEvent() => _ReceiverDownEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error(Error v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);
  @$pb.TagNumber(1)
  Error ensureError() => $_ensure(0);

  @$pb.TagNumber(2)
  HangUp get hangup => $_getN(1);
  @$pb.TagNumber(2)
  set hangup(HangUp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasHangup() => $_has(1);
  @$pb.TagNumber(2)
  void clearHangup() => clearField(2);
  @$pb.TagNumber(2)
  HangUp ensureHangup() => $_ensure(1);
}

class SenderCallStart extends $pb.GeneratedMessage {
  factory SenderCallStart({
    $core.String? clientTokenId,
    $core.Iterable<$core.String>? receiverEmails,
    $core.int? urgency,
    $core.String? subject,
  }) {
    final $result = create();
    if (clientTokenId != null) {
      $result.clientTokenId = clientTokenId;
    }
    if (receiverEmails != null) {
      $result.receiverEmails.addAll(receiverEmails);
    }
    if (urgency != null) {
      $result.urgency = urgency;
    }
    if (subject != null) {
      $result.subject = subject;
    }
    return $result;
  }
  SenderCallStart._() : super();
  factory SenderCallStart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SenderCallStart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SenderCallStart', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientTokenId')
    ..pPS(2, _omitFieldNames ? '' : 'receiverEmails')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'urgency', $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'subject')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SenderCallStart clone() => SenderCallStart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SenderCallStart copyWith(void Function(SenderCallStart) updates) => super.copyWith((message) => updates(message as SenderCallStart)) as SenderCallStart;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SenderCallStart create() => SenderCallStart._();
  SenderCallStart createEmptyInstance() => create();
  static $pb.PbList<SenderCallStart> createRepeated() => $pb.PbList<SenderCallStart>();
  @$core.pragma('dart2js:noInline')
  static SenderCallStart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SenderCallStart>(create);
  static SenderCallStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientTokenId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientTokenId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientTokenId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientTokenId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get receiverEmails => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get urgency => $_getIZ(2);
  @$pb.TagNumber(3)
  set urgency($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUrgency() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrgency() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get subject => $_getSZ(3);
  @$pb.TagNumber(4)
  set subject($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSubject() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubject() => clearField(4);
}

class HangUp extends $pb.GeneratedMessage {
  factory HangUp({
    $core.String? reason,
  }) {
    final $result = create();
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  HangUp._() : super();
  factory HangUp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HangUp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HangUp', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HangUp clone() => HangUp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HangUp copyWith(void Function(HangUp) updates) => super.copyWith((message) => updates(message as HangUp)) as HangUp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HangUp create() => HangUp._();
  HangUp createEmptyInstance() => create();
  static $pb.PbList<HangUp> createRepeated() => $pb.PbList<HangUp>();
  @$core.pragma('dart2js:noInline')
  static HangUp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HangUp>(create);
  static HangUp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => clearField(1);
}

class ReceiverAck extends $pb.GeneratedMessage {
  factory ReceiverAck() => create();
  ReceiverAck._() : super();
  factory ReceiverAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiverAck', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverAck clone() => ReceiverAck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverAck copyWith(void Function(ReceiverAck) updates) => super.copyWith((message) => updates(message as ReceiverAck)) as ReceiverAck;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiverAck create() => ReceiverAck._();
  ReceiverAck createEmptyInstance() => create();
  static $pb.PbList<ReceiverAck> createRepeated() => $pb.PbList<ReceiverAck>();
  @$core.pragma('dart2js:noInline')
  static ReceiverAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiverAck>(create);
  static ReceiverAck? _defaultInstance;
}

class ReceiverAccept extends $pb.GeneratedMessage {
  factory ReceiverAccept() => create();
  ReceiverAccept._() : super();
  factory ReceiverAccept.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverAccept.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiverAccept', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverAccept clone() => ReceiverAccept()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverAccept copyWith(void Function(ReceiverAccept) updates) => super.copyWith((message) => updates(message as ReceiverAccept)) as ReceiverAccept;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiverAccept create() => ReceiverAccept._();
  ReceiverAccept createEmptyInstance() => create();
  static $pb.PbList<ReceiverAccept> createRepeated() => $pb.PbList<ReceiverAccept>();
  @$core.pragma('dart2js:noInline')
  static ReceiverAccept getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiverAccept>(create);
  static ReceiverAccept? _defaultInstance;
}

class ReceiverReject extends $pb.GeneratedMessage {
  factory ReceiverReject() => create();
  ReceiverReject._() : super();
  factory ReceiverReject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverReject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiverReject', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverReject clone() => ReceiverReject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverReject copyWith(void Function(ReceiverReject) updates) => super.copyWith((message) => updates(message as ReceiverReject)) as ReceiverReject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiverReject create() => ReceiverReject._();
  ReceiverReject createEmptyInstance() => create();
  static $pb.PbList<ReceiverReject> createRepeated() => $pb.PbList<ReceiverReject>();
  @$core.pragma('dart2js:noInline')
  static ReceiverReject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiverReject>(create);
  static ReceiverReject? _defaultInstance;
}

class RecipientNotRegistered extends $pb.GeneratedMessage {
  factory RecipientNotRegistered() => create();
  RecipientNotRegistered._() : super();
  factory RecipientNotRegistered.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecipientNotRegistered.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RecipientNotRegistered', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecipientNotRegistered clone() => RecipientNotRegistered()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecipientNotRegistered copyWith(void Function(RecipientNotRegistered) updates) => super.copyWith((message) => updates(message as RecipientNotRegistered)) as RecipientNotRegistered;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecipientNotRegistered create() => RecipientNotRegistered._();
  RecipientNotRegistered createEmptyInstance() => create();
  static $pb.PbList<RecipientNotRegistered> createRepeated() => $pb.PbList<RecipientNotRegistered>();
  @$core.pragma('dart2js:noInline')
  static RecipientNotRegistered getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecipientNotRegistered>(create);
  static RecipientNotRegistered? _defaultInstance;
}

class Error extends $pb.GeneratedMessage {
  factory Error({
    ErrorCode? errorCode,
    $core.String? message,
  }) {
    final $result = create();
    if (errorCode != null) {
      $result.errorCode = errorCode;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  Error._() : super();
  factory Error.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Error', createEmptyInstance: create)
    ..e<ErrorCode>(1, _omitFieldNames ? '' : 'errorCode', $pb.PbFieldType.OE, protoName: 'errorCode', defaultOrMaker: ErrorCode.clientAuthenticationFailed, valueOf: ErrorCode.valueOf, enumValues: ErrorCode.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Error clone() => Error()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Error copyWith(void Function(Error) updates) => super.copyWith((message) => updates(message as Error)) as Error;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  ErrorCode get errorCode => $_getN(0);
  @$pb.TagNumber(1)
  set errorCode(ErrorCode v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

enum SenderUpEvent_Event {
  callStart, 
  hangUp, 
  notSet
}

class SenderUpEvent extends $pb.GeneratedMessage {
  factory SenderUpEvent({
    SenderCallStart? callStart,
    HangUp? hangUp,
  }) {
    final $result = create();
    if (callStart != null) {
      $result.callStart = callStart;
    }
    if (hangUp != null) {
      $result.hangUp = hangUp;
    }
    return $result;
  }
  SenderUpEvent._() : super();
  factory SenderUpEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SenderUpEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, SenderUpEvent_Event> _SenderUpEvent_EventByTag = {
    1 : SenderUpEvent_Event.callStart,
    2 : SenderUpEvent_Event.hangUp,
    0 : SenderUpEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SenderUpEvent', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<SenderCallStart>(1, _omitFieldNames ? '' : 'callStart', protoName: 'callStart', subBuilder: SenderCallStart.create)
    ..aOM<HangUp>(2, _omitFieldNames ? '' : 'hangUp', protoName: 'hangUp', subBuilder: HangUp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SenderUpEvent clone() => SenderUpEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SenderUpEvent copyWith(void Function(SenderUpEvent) updates) => super.copyWith((message) => updates(message as SenderUpEvent)) as SenderUpEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SenderUpEvent create() => SenderUpEvent._();
  SenderUpEvent createEmptyInstance() => create();
  static $pb.PbList<SenderUpEvent> createRepeated() => $pb.PbList<SenderUpEvent>();
  @$core.pragma('dart2js:noInline')
  static SenderUpEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SenderUpEvent>(create);
  static SenderUpEvent? _defaultInstance;

  SenderUpEvent_Event whichEvent() => _SenderUpEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SenderCallStart get callStart => $_getN(0);
  @$pb.TagNumber(1)
  set callStart(SenderCallStart v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallStart() => clearField(1);
  @$pb.TagNumber(1)
  SenderCallStart ensureCallStart() => $_ensure(0);

  @$pb.TagNumber(2)
  HangUp get hangUp => $_getN(1);
  @$pb.TagNumber(2)
  set hangUp(HangUp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasHangUp() => $_has(1);
  @$pb.TagNumber(2)
  void clearHangUp() => clearField(2);
  @$pb.TagNumber(2)
  HangUp ensureHangUp() => $_ensure(1);
}

class NoAnswer extends $pb.GeneratedMessage {
  factory NoAnswer() => create();
  NoAnswer._() : super();
  factory NoAnswer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NoAnswer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NoAnswer', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NoAnswer clone() => NoAnswer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NoAnswer copyWith(void Function(NoAnswer) updates) => super.copyWith((message) => updates(message as NoAnswer)) as NoAnswer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NoAnswer create() => NoAnswer._();
  NoAnswer createEmptyInstance() => create();
  static $pb.PbList<NoAnswer> createRepeated() => $pb.PbList<NoAnswer>();
  @$core.pragma('dart2js:noInline')
  static NoAnswer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NoAnswer>(create);
  static NoAnswer? _defaultInstance;
}

enum SenderDownEvent_Event {
  ack, 
  accept, 
  reject, 
  noAnswer, 
  recipientNotRegistered, 
  error, 
  notSet
}

class SenderDownEvent extends $pb.GeneratedMessage {
  factory SenderDownEvent({
    ReceiverAck? ack,
    ReceiverAccept? accept,
    ReceiverReject? reject,
    NoAnswer? noAnswer,
    RecipientNotRegistered? recipientNotRegistered,
    Error? error,
  }) {
    final $result = create();
    if (ack != null) {
      $result.ack = ack;
    }
    if (accept != null) {
      $result.accept = accept;
    }
    if (reject != null) {
      $result.reject = reject;
    }
    if (noAnswer != null) {
      $result.noAnswer = noAnswer;
    }
    if (recipientNotRegistered != null) {
      $result.recipientNotRegistered = recipientNotRegistered;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  SenderDownEvent._() : super();
  factory SenderDownEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SenderDownEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, SenderDownEvent_Event> _SenderDownEvent_EventByTag = {
    1 : SenderDownEvent_Event.ack,
    2 : SenderDownEvent_Event.accept,
    3 : SenderDownEvent_Event.reject,
    4 : SenderDownEvent_Event.noAnswer,
    5 : SenderDownEvent_Event.recipientNotRegistered,
    6 : SenderDownEvent_Event.error,
    0 : SenderDownEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SenderDownEvent', createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<ReceiverAck>(1, _omitFieldNames ? '' : 'ack', subBuilder: ReceiverAck.create)
    ..aOM<ReceiverAccept>(2, _omitFieldNames ? '' : 'accept', subBuilder: ReceiverAccept.create)
    ..aOM<ReceiverReject>(3, _omitFieldNames ? '' : 'reject', subBuilder: ReceiverReject.create)
    ..aOM<NoAnswer>(4, _omitFieldNames ? '' : 'noAnswer', protoName: 'noAnswer', subBuilder: NoAnswer.create)
    ..aOM<RecipientNotRegistered>(5, _omitFieldNames ? '' : 'recipientNotRegistered', protoName: 'recipientNotRegistered', subBuilder: RecipientNotRegistered.create)
    ..aOM<Error>(6, _omitFieldNames ? '' : 'error', subBuilder: Error.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SenderDownEvent clone() => SenderDownEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SenderDownEvent copyWith(void Function(SenderDownEvent) updates) => super.copyWith((message) => updates(message as SenderDownEvent)) as SenderDownEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SenderDownEvent create() => SenderDownEvent._();
  SenderDownEvent createEmptyInstance() => create();
  static $pb.PbList<SenderDownEvent> createRepeated() => $pb.PbList<SenderDownEvent>();
  @$core.pragma('dart2js:noInline')
  static SenderDownEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SenderDownEvent>(create);
  static SenderDownEvent? _defaultInstance;

  SenderDownEvent_Event whichEvent() => _SenderDownEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ReceiverAck get ack => $_getN(0);
  @$pb.TagNumber(1)
  set ack(ReceiverAck v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAck() => $_has(0);
  @$pb.TagNumber(1)
  void clearAck() => clearField(1);
  @$pb.TagNumber(1)
  ReceiverAck ensureAck() => $_ensure(0);

  @$pb.TagNumber(2)
  ReceiverAccept get accept => $_getN(1);
  @$pb.TagNumber(2)
  set accept(ReceiverAccept v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => clearField(2);
  @$pb.TagNumber(2)
  ReceiverAccept ensureAccept() => $_ensure(1);

  @$pb.TagNumber(3)
  ReceiverReject get reject => $_getN(2);
  @$pb.TagNumber(3)
  set reject(ReceiverReject v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReject() => $_has(2);
  @$pb.TagNumber(3)
  void clearReject() => clearField(3);
  @$pb.TagNumber(3)
  ReceiverReject ensureReject() => $_ensure(2);

  @$pb.TagNumber(4)
  NoAnswer get noAnswer => $_getN(3);
  @$pb.TagNumber(4)
  set noAnswer(NoAnswer v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNoAnswer() => $_has(3);
  @$pb.TagNumber(4)
  void clearNoAnswer() => clearField(4);
  @$pb.TagNumber(4)
  NoAnswer ensureNoAnswer() => $_ensure(3);

  @$pb.TagNumber(5)
  RecipientNotRegistered get recipientNotRegistered => $_getN(4);
  @$pb.TagNumber(5)
  set recipientNotRegistered(RecipientNotRegistered v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRecipientNotRegistered() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipientNotRegistered() => clearField(5);
  @$pb.TagNumber(5)
  RecipientNotRegistered ensureRecipientNotRegistered() => $_ensure(4);

  @$pb.TagNumber(6)
  Error get error => $_getN(5);
  @$pb.TagNumber(6)
  set error(Error v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasError() => $_has(5);
  @$pb.TagNumber(6)
  void clearError() => clearField(6);
  @$pb.TagNumber(6)
  Error ensureError() => $_ensure(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
