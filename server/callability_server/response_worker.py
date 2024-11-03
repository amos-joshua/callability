
from callability_server import firebase_utils
from callability_server.message_board import MessageBoard
from callability_server.firebase_utils import call_log_info, call_log_warn, call_log_error

class InvalidCallUuid(Exception):
    """An invalid call uuid was encountered"""

class NoSuchCall(Exception):
    "Unknown call uuid or user not authorized for call"

class ResponseWorker:
    def __init__(self, call_uuid: str, message_board: MessageBoard):
        self.call_uuid = call_uuid
        self.message_board = message_board

    def log_info(self, message):
        call_log_info(self.call_uuid, f"[RespondToCall] {message}")

    def log_warn(self, message):
        call_log_warn(self.call_uuid, f"[RespondToCall] {message}")

    def log_error(self, message):
        call_log_error(self.call_uuid, f"[RespondToCall] {message}")

    def process_request(self, request):
        self.log_info(f"server received call response '{request.WhichOneof("event")}'")
        self._authenticate_user(request.client_token_id)
        self._handle_response_message(request.WhichOneof("event"))

    def _verify_call_uuid(self):
        if not isinstance(self.call_uuid, str):
            raise InvalidCallUuid(f"not a string, found a {type(self.call_uuid)}")
        elif len(self.call_uuid.strip()) == 0:
            raise InvalidCallUuid(f"empty")

    def _authenticate_user(self, client_token_id: str):
        user_data = firebase_utils.verify_client_token_id(client_token_id)
        self._verify_call_uuid()

        self.log_info(f"verified receiver auth")

        session_devices = firebase_utils.device_tokens_for_call(self.call_uuid)
        if len(session_devices) == 0:
            raise NoSuchCall()

        user_devices = firebase_utils.device_tokens_for_user_uid(user_data.get('user_id', ''))
        self.log_info(f"Found {len(user_devices)} devices for recipient")
        receiver_allowed = any(device in session_devices for device in user_devices)

        if not receiver_allowed:
            raise firebase_utils.FirebaseUserAuthenticationError()

    def _handle_response_message(self, response_type: str):
        allowed_events = ["ack", "accept", "reject"]
        if response_type in allowed_events:
            self.log_info(f"publishing receiver response '{response_type}' to message board")
            self.message_board.publish(self.call_uuid, response_type)
        else:
            raise RuntimeError(f"Unknown ReceiverUpEvent {response_type} which is a {type(response_type)}, expected one of {allowed_events}")