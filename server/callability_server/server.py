import grpc
import concurrent.futures
import sys
import firebase_admin
import firebase_admin.auth
import firebase_admin.credentials
import firebase_admin.db
import firebase_admin.messaging
import traceback

from callability_server.call_worker import CallWorker, RecipientNotRegistered
from callability_server.firebase_utils import call_log_error, call_log_info
from callability_server.response_worker import NoSuchCall
from callability_server.response_worker import ResponseWorker, InvalidCallUuid
from callability_server.message_board import MessageBoard
from callability_server import firebase_utils

sys.path.append("./protobuf")
import protobuf.service_pb2_grpc
import protobuf.service_pb2 as pb2

class CallabilityServer(protobuf.service_pb2_grpc.CallabilitySwitchboardServicer):
    def __init__(self):
        # NOTE: this assumes service account path is in the
        #       env variable GOOGLE_APPLICATION_CREDENTIALS
        #       (or alternatively auto-init if run in google vm)
        self.firebase: firebase_admin.App = firebase_admin.initialize_app(
            options = {
                'databaseURL': 'https://callability-56e94-default-rtdb.europe-west1.firebasedatabase.app',
                'databaseAuthVariableOverride': {
                    'uid': 'server-admin'
                }
            }
        )
        self.message_board = MessageBoard()

    def RespondToCall(self, request, context):
        call_uuid: str = '(unknown-uuid)'
        try:
            call_uuid = request.call_uuid
        except:
            print(f"ERROR retrieving call_uuid from request {request}")

        try:
            response_worker = ResponseWorker(request.call_uuid, message_board=self.message_board)
            response_worker.process_request(request)
            return pb2.ReceiverDownEvent()
        
        except InvalidCallUuid as exc:
            print(f"ERROR received invalid call uuid {call_uuid}")
            return pb2.ReceiverDownEvent(
                error=pb2.Error(pb2.ErrorCode.serverError, f"Invalid call uuid: {exc}"))

        except firebase_utils.FirebaseUserAuthenticationError:
            call_log_error(call_uuid, f"[RespondToCall] {traceback.format_exc()}")
            return pb2.ReceiverDownEvent(
                error=pb2.Error(pb2.ErrorCode.clientAuthenticationFailed, "Responding from an unauthenticated device"))

        except NoSuchCall:
            call_log_error(call_uuid, f"[RespondToCall] {traceback.format_exc()}")
            return pb2.ReceiverDownEvent(hangup=pb2.HangUp(reason="no such call (another device answered?)"))

        except:
            call_log_error(call_uuid, f"[RespondToCall] {traceback.format_exc()}")
            return pb2.ReceiverDownEvent(
                error=pb2.Error(pb2.ErrorCode.serverError, f"Server error (call {call_uuid})"))


    def InitiateCall(self, request_iterator, context):
        call_worker = CallWorker(self.message_board)

        try:
            yield from call_worker.process_request(request_iterator)

        except RecipientNotRegistered:
            call_worker.log_error(traceback.format_exc())
            yield pb2.SenderDownEvent(recipientNotRegistered=pb2.RecipientNotRegistered())

        except firebase_utils.FirebaseUserAuthenticationError as exc:
            call_worker.log_error(traceback.format_exc())
            yield pb2.SenderDownEvent(
                error=pb2.Error(pb2.ErrorCode.clientAuthenticationFailed, "Calling from an unauthenticated device"))

        except Exception as exc:
            call_worker.log_error(f"Server error: {traceback.format_exc()}")
            yield pb2.ReceiverDownEvent(error=pb2.Error(pb2.ErrorCode.serverError, message=f"{repr(exc)} (incident {incident_uuid})"))

        finally:
            self.message_board.close(call_worker.call_uuid)
        call_worker.log_info("Call initiation finished")

    def Health(self, request, context):
        try:
            return pb2.ServerStatus(status="ok")
        except Exception:
            traceback.print_exc()
            return pb2.ServerStatus(status="error")


def serve(port=50051, max_thread_workers=10):
    server = grpc.server(concurrent.futures.ThreadPoolExecutor(max_workers=max_thread_workers))
    protobuf.service_pb2_grpc.add_CallabilitySwitchboardServicer_to_server(CallabilityServer(), server)
    server.add_insecure_port(f"[::]:{port}")
    server.add_insecure_port(f"127.0.0.1:{port}")
    server.start()
    server.wait_for_termination()