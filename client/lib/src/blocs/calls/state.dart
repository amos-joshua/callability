import 'package:equatable/equatable.dart';
import '../../model/model.dart';

class CallsState extends Equatable {
  final List<Call> calls;

  const CallsState({
    this.calls = const [],
  });

  CallsState copyWith({
    List<Call>? calls,
  }) => CallsState(calls: calls ?? this.calls);

  @override
  List<Object> get props => [...calls.map((call) => call.id)];
}

class CurrentCallState extends Equatable {
  final Contact? contact;
  final CallUrgency urgency;
  final String email;
  final String subject;
  final CallStatus callStatus;
  final String? callError;
  final String callUuid;

  const CurrentCallState({
    this.contact,
    this.urgency = CallUrgency.leisure,
    this.email = '',
    this.subject = '',
    this.callStatus = CallStatus.composing,
    this.callError,
    this.callUuid = ''
  });

  CurrentCallState copyWith({
    Contact? contact,
    CallUrgency? urgency,
    String? email,
    String? subject,
    bool noContact = false,
    CallStatus? callStatus,
    String? callError,
    String? callUuid,
  }) => CurrentCallState(contact: contact ?? (noContact ? null : this.contact), urgency: urgency ?? this.urgency, email: email ?? this.email, subject: subject ?? this.subject, callStatus: callStatus ?? this.callStatus, callError: callError ?? this.callError, callUuid: callUuid ?? this.callUuid);

  @override
  List<Object?> get props => [contact?.displayName ?? '', urgency, email, subject, callStatus, callUuid, callError];
}