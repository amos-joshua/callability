
import 'enums.dart';

List<String> _validateCallUuid(dynamic callUuid) {
  final errors = <String>[];
  if (callUuid is! String) {
    errors.add('Expected call_uuid to be a String but found ${callUuid.runtimeType}');
  }
  else if (callUuid.trim().isEmpty) {
    errors.add('Expected call_uuid to be nonempty');
  }
  return errors;
}

abstract class FirebasePayload {
  final String callUuid;
  FirebasePayload({required this.callUuid});

  static (FirebasePayload?, List<String>) parse(Map<String, dynamic> data) {
    return switch(data["call_event"]) {
      "hang_up" => HangUpFirebasePayload.parse(data),
      "start_call" => IncomingCallFirebasePayload.parse(data),
      _ => (null, ["unknown event type '${data['call_event']}'"])
    };
  }
}

class HangUpFirebasePayload extends FirebasePayload {

  HangUpFirebasePayload({required super.callUuid});

  static (HangUpFirebasePayload?, List<String>) parse(Map<String, dynamic> data) {
    final callUuid = data['call_uuid'];

    final errors = <String>[];
    errors.addAll(_validateCallUuid(callUuid));

    if (errors.isEmpty) {
      final payload = HangUpFirebasePayload(
          callUuid: callUuid
      );
      return (payload, errors);
    }
    return (null, errors);
  }
}

class IncomingCallFirebasePayload extends FirebasePayload {
  final String email;
  final String subject;
  final CallUrgency urgency;
  IncomingCallFirebasePayload({
    required this.email,
    required this.subject,
    required this.urgency,
    required super.callUuid
  });

  static (IncomingCallFirebasePayload?, List<String>) parse(Map<String, dynamic> data) {
    final email = data['caller_email'];
    final subject = data['subject'];
    final callUuid = data['call_uuid'];
    final urgencyStr = data['urgency'];

    final errors = <String>[];

    if (email is! String) {
      errors.add('Expected email key to be a String but found ${email.runtimeType}');
    }
    else if (email.isEmpty) {
      errors.add('Expected email to be nonempty');
    }

    if (subject is! String) {
      errors.add('Expected subject to be a String but found ${subject.String}');
    }
    errors.addAll(_validateCallUuid(callUuid));

    if (urgencyStr is! String) {
      errors.add('Expected urgency to be a String but found ${urgencyStr.runtimeType}');
    }
    var urgency = CallUrgency.leisure;
    try {
      urgency = CallUrgency.values[int.parse(urgencyStr)];
    }
    catch (exc) {
      errors.add('Invalid urgency value: $exc');
    }

    if (errors.isEmpty) {
      final payload = IncomingCallFirebasePayload(
          email: email,
          subject: subject,
          urgency: urgency,
          callUuid: callUuid
      );
      return (payload, errors);
    }
    return (null, errors);
  }
}
