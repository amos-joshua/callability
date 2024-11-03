import queue
from queue import Queue

class MessageBoard:

    def __init__(self):
        self.queues: dict[str, Queue] = {}

    def createChannel(self, subject: str):
        if self.queues.get(subject, None) is None:
            self.queues[subject] = Queue(maxsize=10)

    def publish(self, subject: str, value):
        self.createChannel(subject)
        self.queues[subject].put(value)

    def close(self, subject:str ):
        del self.queues[subject]

    def get_with_timeout(self, subject:str , timeout:int = 60):
        self.createChannel(subject)
        try:
            return self.queues[subject].get(timeout=timeout)
        except queue.Empty:
            return None
        except queue.ShutDown:
            return None
