# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc
import warnings

import service_pb2 as service__pb2

GRPC_GENERATED_VERSION = '1.67.0'
GRPC_VERSION = grpc.__version__
_version_not_supported = False

try:
    from grpc._utilities import first_version_is_lower
    _version_not_supported = first_version_is_lower(GRPC_VERSION, GRPC_GENERATED_VERSION)
except ImportError:
    _version_not_supported = True

if _version_not_supported:
    raise RuntimeError(
        f'The grpc package installed is at version {GRPC_VERSION},'
        + f' but the generated code in service_pb2_grpc.py depends on'
        + f' grpcio>={GRPC_GENERATED_VERSION}.'
        + f' Please upgrade your grpc module to grpcio>={GRPC_GENERATED_VERSION}'
        + f' or downgrade your generated code using grpcio-tools<={GRPC_VERSION}.'
    )


class CallabilitySwitchboardStub(object):
    """Missing associated documentation comment in .proto file."""

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.InitiateCall = channel.stream_stream(
                '/CallabilitySwitchboard/InitiateCall',
                request_serializer=service__pb2.SenderUpEvent.SerializeToString,
                response_deserializer=service__pb2.SenderDownEvent.FromString,
                _registered_method=True)
        self.RespondToCall = channel.unary_unary(
                '/CallabilitySwitchboard/RespondToCall',
                request_serializer=service__pb2.ReceiverUpEvent.SerializeToString,
                response_deserializer=service__pb2.ReceiverDownEvent.FromString,
                _registered_method=True)
        self.Health = channel.unary_unary(
                '/CallabilitySwitchboard/Health',
                request_serializer=service__pb2.ServerStatusInquiry.SerializeToString,
                response_deserializer=service__pb2.ServerStatus.FromString,
                _registered_method=True)


class CallabilitySwitchboardServicer(object):
    """Missing associated documentation comment in .proto file."""

    def InitiateCall(self, request_iterator, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def RespondToCall(self, request, context):
        """rpc AnswerCall(stream ReceiverUpEvent) returns (stream ReceiverDownEvent);
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def Health(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_CallabilitySwitchboardServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'InitiateCall': grpc.stream_stream_rpc_method_handler(
                    servicer.InitiateCall,
                    request_deserializer=service__pb2.SenderUpEvent.FromString,
                    response_serializer=service__pb2.SenderDownEvent.SerializeToString,
            ),
            'RespondToCall': grpc.unary_unary_rpc_method_handler(
                    servicer.RespondToCall,
                    request_deserializer=service__pb2.ReceiverUpEvent.FromString,
                    response_serializer=service__pb2.ReceiverDownEvent.SerializeToString,
            ),
            'Health': grpc.unary_unary_rpc_method_handler(
                    servicer.Health,
                    request_deserializer=service__pb2.ServerStatusInquiry.FromString,
                    response_serializer=service__pb2.ServerStatus.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'CallabilitySwitchboard', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))
    server.add_registered_method_handlers('CallabilitySwitchboard', rpc_method_handlers)


 # This class is part of an EXPERIMENTAL API.
class CallabilitySwitchboard(object):
    """Missing associated documentation comment in .proto file."""

    @staticmethod
    def InitiateCall(request_iterator,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.stream_stream(
            request_iterator,
            target,
            '/CallabilitySwitchboard/InitiateCall',
            service__pb2.SenderUpEvent.SerializeToString,
            service__pb2.SenderDownEvent.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def RespondToCall(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/CallabilitySwitchboard/RespondToCall',
            service__pb2.ReceiverUpEvent.SerializeToString,
            service__pb2.ReceiverDownEvent.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def Health(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/CallabilitySwitchboard/Health',
            service__pb2.ServerStatusInquiry.SerializeToString,
            service__pb2.ServerStatus.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)
