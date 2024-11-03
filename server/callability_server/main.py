import argparse
import importlib.metadata
import logging

from callability_server import server

def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", help="port (defaults to 50051)", type=int, default=50051)
    args = parser.parse_args()

    app_version = importlib.metadata.version('callability-server')

    print(f"Starting grpc server {app_version} on port {args.port}...")
    print("")

    logging.basicConfig(level=logging.INFO)
    server.serve(port=args.port, max_thread_workers=10)


if __name__ == "__main__":
    cli()
