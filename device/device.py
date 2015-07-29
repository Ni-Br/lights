#Example imported from <https://docs.python.org/2/library/socketserver.html>
import sys
import fileinput
import socket
import time

IP = sys.argv[1]
PORT = int(sys.argv[2])
BUFFER_SIZE = 20
count = 0
start = 0

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((IP, PORT))
s.listen(1)

conn, addr = s.accept()
sfile = conn.makefile("rwb")
print("Connection from:", addr)
start = time.time()

try:
    while True:
        data = sfile.readline().strip()
        if not data:
            break

        print("Received", data)
        conn.sendall((str(time.time()) + "\n").encode())
        count +=1
except:
    conn.close()

end = time.time()
print(count, "frames in", end-start, "seconds. FPS of", count/(end-start))
