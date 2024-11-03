
import 'package:objectbox/objectbox.dart';
import '../model/model.dart';

@Entity()
class Call {

  @Id()
  int id;

  final contact = ToOne<Contact>();

  bool get incoming => !outgoing;
  bool outgoing;

  @Transient()
  CallUrgency urgency;

  String subject;

  DateTime startTime;
  DateTime? endTime;
  bool answered;

  int get dbUrgency => urgency.index;
  set dbUrgency(int index) {
    urgency = CallUrgency.values[index];
  }

  Call({this.id = 0, this.outgoing = true, this.urgency = CallUrgency.leisure, required this.subject, required this.startTime, this.endTime, this.answered = true});

  @override
  String toString() => 'Call(id $id, contact: $contact, subject: $subject, urgency: $urgency)';
}

enum CallEvent {
  incomingCallStart,
  incomingCallHangUp,
  incomingCallAccepted,
  incomingCallRejected
}