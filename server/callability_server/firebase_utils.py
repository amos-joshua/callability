from typing import Any

import firebase_admin
import firebase_admin.auth
import firebase_admin.db
import firebase_admin.messaging
import traceback
import datetime


class FirebaseUserAuthenticationError(Exception):
    """verification of a client token id failed"""


log_nonce = 0

def verify_client_token_id(client_token_id) -> dict:
    try:
        decoded_token = firebase_admin.auth.verify_id_token(client_token_id)
        return decoded_token
    except:
        raise FirebaseUserAuthenticationError()


def users_for_emails(emails: list[str]) -> (list[firebase_admin.auth.UserRecord], list[str]):
    recipient_users: list[firebase_admin.auth.UserRecord] = []
    invalid_user_errors: list[str] = []
    for email in emails:
        try:
            user = firebase_admin.auth.get_user_by_email(email)
            recipient_users.append(user)
        except:
            invalid_user_errors.append(f"email '{email}' did not correspond to any user: {traceback.format_exc(limit=1)}")
    return recipient_users, invalid_user_errors


def device_tokens_for_user_uid(uid: str) -> list[str]:
    user_devices_path = f"/users/{uid}/devices"
    devices = firebase_admin.db.reference(user_devices_path).get()
    if isinstance(devices, dict):
        return list(devices.keys())
    else:
        print(f"WARN devices entry for {uid} is unexpectedly {type(devices)} but expected a dict. Returning empty device list")
    return []

def device_tokens_for_user_uids(user_uids: list[str]) -> list[str]:
    return [token for user_uid in user_uids for token in device_tokens_for_user_uid(user_uid)]

def create_call_entry(call_uuid: str, device_tokens: list[str]):
    calls = firebase_admin.db.reference(f"/calls/{call_uuid}")
    calls.update({
        'devices': device_tokens
    })


def send_firebase_message(data: dict[str, Any], tokens: list[str]) -> list[Exception]:
    message = firebase_admin.messaging.MulticastMessage(
        data=data,
        tokens=tokens,
        android=firebase_admin.messaging.AndroidConfig(
            priority="high"
        )
    )

    responses: list[
        firebase_admin.messaging.SendResponse] = firebase_admin.messaging.send_each_for_multicast(message).responses
    errors: list[Exception]= [response.exception for response in responses if not response.success]
    return errors

def device_tokens_for_call(call_uuid: str) -> list[str]:
    devices = firebase_admin.db.reference(f"/calls/{call_uuid}/devices").get()
    if isinstance(devices, list):
        return devices

    call_log_warn(call_uuid, "call uuid has no entry in firebase db")
    return []

def call_log_info(call_uuid, event):
    global log_nonce
    timestamp = datetime.datetime.now().isoformat().replace('.', ':')
    firebase_admin.db.reference(f"/calls/{call_uuid}/log").update({f'{timestamp}_{log_nonce}': event})
    log_nonce += 1

def call_log_warn(call_uuid, event):
    print(f"WARNING [{call_uuid}]: {event}")
    call_log_info(call_uuid, event)
    #firebase_admin.db.reference(f"/calls/{call_uuid}").update({'had_warning': True})


def call_log_error(call_uuid:str , event: str):
    print(f"ERROR [{call_uuid}]: {event}")
    call_log_info(call_uuid, event)
    #firebase_admin.db.reference(f"/calls/{call_uuid}").update({'had_error': True})
