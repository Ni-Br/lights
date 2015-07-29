import struct
import spidev
import sys
import socket
import time

def toDevice(rgbs):
    values = [0, 0, 0, 0]

    #Transform 8-bit value to 5-bit
    for (r,g,b) in rgbs:
        r = int(r) >> 3
        g = int(g) >> 3
        b = int(b) >> 3
        values.append((0x80 | (b<<2) | ((r&0x18)>>3)))
        values.append((((r&0x07)<<5) | g)) 

    #Add a single 1 bit for every pixel
    for i in range(int(len(rgb)/8)+1):
        values.append(0xFF)

    spi.writebytes(values)

#Initial setup
IP = sys.argv[1]
PORT = int(sys.argv[2])
BUFFER_SIZE = 20
count = 0
start = 0

#Start SPI
spi = spidev.SpiDev()
spi.open(0,0)

#Start listening
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((IP, PORT))
s.listen(1)

#Connected!
conn, addr = s.accept()
sfile = conn.makefile("rwb")
print("Connection from:", addr)
start = time.time()

try:
    while True:
        data = sfile.readline().strip()
        if not data:
            break

        pixels = data.split("#")
        rgbs = [struct.unpack('BBB', bytes.fromhex(p)) for p in pixels]
        toDevice(rgs)
        
        conn.sendall((str(time.time()) + "\n").encode())
        count +=1
except:
    conn.close()

end = time.time()
spi.close()
print(count, "frames in", end-start, "seconds. FPS of", count/(end-start))
