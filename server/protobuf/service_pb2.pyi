from google.protobuf.internal import containers as _containers
from google.protobuf.internal import enum_type_wrapper as _enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class ErrorCode(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    clientAuthenticationFailed: _ClassVar[ErrorCode]
    serverError: _ClassVar[ErrorCode]
    noSuchSession: _ClassVar[ErrorCode]
clientAuthenticationFailed: ErrorCode
serverError: ErrorCode
noSuchSession: ErrorCode

class ServerStatusInquiry(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class ServerStatus(_message.Message):
    __slots__ = ("status",)
    STATUS_FIELD_NUMBER: _ClassVar[int]
    status: str
    def __init__(self, status: _Optional[str] = ...) -> None: ...

class ReceiverUpEvent(_message.Message):
    __slots__ = ("client_token_id", "call_uuid", "ack", "accept", "reject")
    CLIENT_TOKEN_ID_FIELD_NUMBER: _ClassVar[int]
    CALL_UUID_FIELD_NUMBER: _ClassVar[int]
    ACK_FIELD_NUMBER: _ClassVar[int]
    ACCEPT_FIELD_NUMBER: _ClassVar[int]
    REJECT_FIELD_NUMBER: _ClassVar[int]
    client_token_id: str
    call_uuid: str
    ack: ReceiverAck
    accept: ReceiverAccept
    reject: ReceiverReject
    def __init__(self, client_token_id: _Optional[str] = ..., call_uuid: _Optional[str] = ..., ack: _Optional[_Union[ReceiverAck, _Mapping]] = ..., accept: _Optional[_Union[ReceiverAccept, _Mapping]] = ..., reject: _Optional[_Union[ReceiverReject, _Mapping]] = ...) -> None: ...

class ReceiverDownEvent(_message.Message):
    __slots__ = ("error", "hangup")
    ERROR_FIELD_NUMBER: _ClassVar[int]
    HANGUP_FIELD_NUMBER: _ClassVar[int]
    error: Error
    hangup: HangUp
    def __init__(self, error: _Optional[_Union[Error, _Mapping]] = ..., hangup: _Optional[_Union[HangUp, _Mapping]] = ...) -> None: ...

class SenderCallStart(_message.Message):
    __slots__ = ("client_token_id", "receiver_emails", "urgency", "subject")
    CLIENT_TOKEN_ID_FIELD_NUMBER: _ClassVar[int]
    RECEIVER_EMAILS_FIELD_NUMBER: _ClassVar[int]
    URGENCY_FIELD_NUMBER: _ClassVar[int]
    SUBJECT_FIELD_NUMBER: _ClassVar[int]
    client_token_id: str
    receiver_emails: _containers.RepeatedScalarFieldContainer[str]
    urgency: int
    subject: str
    def __init__(self, client_token_id: _Optional[str] = ..., receiver_emails: _Optional[_Iterable[str]] = ..., urgency: _Optional[int] = ..., subject: _Optional[str] = ...) -> None: ...

class HangUp(_message.Message):
    __slots__ = ("reason",)
    REASON_FIELD_NUMBER: _ClassVar[int]
    reason: str
    def __init__(self, reason: _Optional[str] = ...) -> None: ...

class ReceiverAck(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class ReceiverAccept(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class ReceiverReject(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class RecipientNotRegistered(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class Error(_message.Message):
    __slots__ = ("errorCode", "message")
    ERRORCODE_FIELD_NUMBER: _ClassVar[int]
    MESSAGE_FIELD_NUMBER: _ClassVar[int]
    errorCode: ErrorCode
    message: str
    def __init__(self, errorCode: _Optional[_Union[ErrorCode, str]] = ..., message: _Optional[str] = ...) -> None: ...

class SenderUpEvent(_message.Message):
    __slots__ = ("callStart", "hangUp")
    CALLSTART_FIELD_NUMBER: _ClassVar[int]
    HANGUP_FIELD_NUMBER: _ClassVar[int]
    callStart: SenderCallStart
    hangUp: HangUp
    def __init__(self, callStart: _Optional[_Union[SenderCallStart, _Mapping]] = ..., hangUp: _Optional[_Union[HangUp, _Mapping]] = ...) -> None: ...

class NoAnswer(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class SenderDownEvent(_message.Message):
    __slots__ = ("ack", "accept", "reject", "noAnswer", "recipientNotRegistered", "error")
    ACK_FIELD_NUMBER: _ClassVar[int]
    ACCEPT_FIELD_NUMBER: _ClassVar[int]
    REJECT_FIELD_NUMBER: _ClassVar[int]
    NOANSWER_FIELD_NUMBER: _ClassVar[int]
    RECIPIENTNOTREGISTERED_FIELD_NUMBER: _ClassVar[int]
    ERROR_FIELD_NUMBER: _ClassVar[int]
    ack: ReceiverAck
    accept: ReceiverAccept
    reject: ReceiverReject
    noAnswer: NoAnswer
    recipientNotRegistered: RecipientNotRegistered
    error: Error
    def __init__(self, ack: _Optional[_Union[ReceiverAck, _Mapping]] = ..., accept: _Optional[_Union[ReceiverAccept, _Mapping]] = ..., reject: _Optional[_Union[ReceiverReject, _Mapping]] = ..., noAnswer: _Optional[_Union[NoAnswer, _Mapping]] = ..., recipientNotRegistered: _Optional[_Union[RecipientNotRegistered, _Mapping]] = ..., error: _Optional[_Union[Error, _Mapping]] = ...) -> None: ...
