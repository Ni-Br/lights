#Example imported from <https://docs.python.org/2/library/socketserver.html>
import socket
import time

IP = "localhost"
PORT = 9999
BUFFER_SIZE = 20

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((IP, PORT))
s.listen(1)

conn, addr = s.accept()
sfile = conn.makefile("rwb")
print("Connection from:", addr)
while True:
    data = sfile.readline().strip()
    if not data:
        break

    print("Received", data)
    sfile.write((str(time.time()) + "\n").encode())
    sfile.flush()

conn.close()
