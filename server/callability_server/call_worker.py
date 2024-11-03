import sys
import threading

sys.path.append("./protobuf")
import protobuf.service_pb2 as pb2
import uuid

from callability_server.message_board import MessageBoard
from callability_server import firebase_utils
from callability_server.firebase_utils import call_log_info, call_log_warn, call_log_error

class RecipientNotRegistered(Exception):
    """The given recipient is not registered on the server"""

class CallWorker:
    call_timeout = 30

    def __init__(self, message_board: MessageBoard):
        self.message_board = message_board
        self.call_uuid = uuid.uuid4().hex
        self.message_board.createChannel(self.call_uuid)
        self.device_tokens = []

    def log_info(self, message):
        call_log_info(self.call_uuid, f"[InitiateCall] {message}")
    
    def log_warn(self, message):
        call_log_warn(self.call_uuid, f"[InitiateCall] {message}")
        
    def log_error(self, message):
        call_log_error(self.call_uuid, f"[InitiateCall] {message}")
        
    def process_request(self, request_iterator):
        self.log_info("initiated call")
        self._process_call_start(request_iterator)
        next_events_thread = threading.Thread(target=self._process_next_sender_events, args=(request_iterator,))
        next_events_thread.start()
        yield from self._process_events()

    def _process_next_sender_events(self, request_iterator):
        for request in request_iterator:
            if request.HasField("hangUp"):
                self.log_info(f"sender sent hang-up on grpc thread, publishing to message board")
                self.message_board.publish(self.call_uuid, "sender-hang-up")
            else:
                print(f"WARNING Ignoring unexpected sender event {request.WhichOneOf()}, expected an optional HangUp")


    def _process_call_start(self, request_iterator):
        request = next(request_iterator)
        #print(f"DBG got {request}")
        if not request.HasField("callStart"):
            raise RuntimeError(f"Connection started with '{request.WhichOneOf()}' but expected CallStart")
        user_dict = firebase_utils.verify_client_token_id(request.callStart.client_token_id)
        # print(f"DBG decoded user dict: {user_dict} for call start {request.callStart}")

        self.log_info("authenticated caller")
        recipients, invalid_user_errors = firebase_utils.users_for_emails(request.callStart.receiver_emails)
        if len(invalid_user_errors) > 0:
            self.log_warn(f"had errors retrieving '{len(invalid_user_errors)} users: {"\n".join(invalid_user_errors)}. Continuing with {len(recipients)} that were successfully retrieved")

        self.device_tokens = firebase_utils.device_tokens_for_user_uids([recipient.uid for recipient in recipients])
        if len(self.device_tokens) == 0:
            self.log_error(f"no device tokens matching recipients [{recipients}]")
            raise RecipientNotRegistered()

        #print(f"DBG found {len(self.device_tokens)} devices for users")
        firebase_utils.create_call_entry(self.call_uuid, self.device_tokens)

        message_data = {
            "call_event": "start_call",
            "call_uuid": f"{self.call_uuid}",
            "caller_email": user_dict.get("email", "(unknown email)"),
            "caller_display_name": user_dict.get("name", "(unknown)"),
            "subject": request.callStart.subject,
            "urgency": f"{request.callStart.urgency}"
        }
        errors = firebase_utils.send_firebase_message(message_data, self.device_tokens)
        if len(errors) > 0:
            self.log_error(f"ERROR sending push notification: {"\n".join([repr(error) for error in errors])}")
        else:
            self.log_info(f"sent push notifications to {len(self.device_tokens)} devices")

    def _process_events(self):
        self.log_info(f"waiting {self.call_timeout}s for a reply from recipient")

        max_events = 5 # if we get more than 5 events, something somewhere is wrong, so hang up
        for event in range(max_events):
            next_event = self.message_board.get_with_timeout(self.call_uuid, timeout=self.call_timeout)

            if next_event == 'ack':
                self.log_info("sending ACK server->sender")
                yield pb2.SenderDownEvent(ack=pb2.ReceiverAck())
                continue
            elif next_event == 'accept':
                self.log_info("sending ACCEPT server->sender")
                yield pb2.SenderDownEvent(accept=pb2.ReceiverAccept())
                return
            elif next_event == 'reject':
                self.log_info("sending REJECT server->sender")
                yield pb2.SenderDownEvent(reject=pb2.ReceiverReject())
                return
            elif next_event == 'sender-hang-up':
                self.log_info(f"sender hung up")
                self._send_hang_up_push_notification()
                break
            elif next_event is None:
                self.log_info(f"Call timed out")
                self._send_hang_up_push_notification()
                yield pb2.SenderDownEvent(noAnswer=pb2.NoAnswer())
                break
            else:
                self.log_warn(f"received unexpected event '{next_event}'")

    def _send_hang_up_push_notification(self):
        message_data = {
            "call_event": "hang_up",
            "call_uuid": f"{self.call_uuid}"
        }
        errors = firebase_utils.send_firebase_message(message_data, self.device_tokens)
        if len(errors) > 0:
            self.log_info(f"Call timed out")
        else:
            self.log_info(f"Sent hang up push notification to {len(self.device_tokens)} receiver devices")

