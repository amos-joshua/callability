import grpc
from protobuf import service_pb2_grpc as pb2_grpc
import protobuf.service_pb2 as pb2


import argparse

def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", help="port (defaults to 50051)", type=int, default=50051)
    parser.add_argument("--host", help="host (defaults to localhost)", type=str, default="localhost")
    args = parser.parse_args()

    print(f"========================================")
    print(f"Checking server status {args.host}:{args.port}")

    #channel = grpc.insecure_channel(f'{args.host}:{args.port}')
    channel = grpc.secure_channel(args.host, grpc.ssl_channel_credentials())
    stub = pb2_grpc.CallabilitySwitchboardStub(channel)

    req = pb2.ServerStatusInquiry()
    status = stub.Health(req)
    print(f"Server status: {status}")

if __name__ == "__main__":
    cli()
