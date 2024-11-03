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

class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode clientAuthenticationFailed = ErrorCode._(0, _omitEnumNames ? '' : 'clientAuthenticationFailed');
  static const ErrorCode serverError = ErrorCode._(1, _omitEnumNames ? '' : 'serverError');
  static const ErrorCode noSuchSession = ErrorCode._(2, _omitEnumNames ? '' : 'noSuchSession');

  static const $core.List<ErrorCode> values = <ErrorCode> [
    clientAuthenticationFailed,
    serverError,
    noSuchSession,
  ];

  static final $core.Map<$core.int, ErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ErrorCode? valueOf($core.int value) => _byValue[value];

  const ErrorCode._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
