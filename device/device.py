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
    for i in range(int(len(rgbs)/8)+1):
        values.append(0xFF)

    spi.writebytes(values)

#Initial setup
IP = sys.argv[1]
PORT = int(sys.argv[2])
BUFFER_SIZE = 20
max_fps = 60
max_period = 1.0/max_fps
count = 0
start = 0

#Start SPI
spi = spidev.SpiDev()
spi.open(0,0)
print("SPI is setup.")

#Start listening
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((IP, PORT))
s.listen(1)
print("Network is setup. Listening on", IP+":"+str(PORT))


try:
    while True:
        #Connected!
        conn, addr = s.accept()
        sfile = conn.makefile("rwb")
        print("Connection from:", addr)
        start = time.time()

        #Initial
        conn.sendall((str(time.time()) + "\n").encode())
        conn.sendall((str(time.time()) + "\n").encode())
        t = time.time()
        while True:
            try:
                data = str(sfile.readline().strip())

                #Should be sent as soon after receiving data, but limiting at ~60fps
                time.sleep(max(0, t+max_period-time.time()))
                t = time.time()
                conn.sendall((str(t) + "\n").encode())

                data = str(data.strip("'"))

                pixels = data.split("#")[1:]
                rgbs = [struct.unpack('BBB', bytes.fromhex(p)) for p in pixels]
                toDevice(rgbs)
            
                count +=1
            except Exception as e:
                end = time.time()
                conn.close()
                print(e)
                print(count, "frames in", end-start, "seconds. FPS of", count/(end-start))
                count = 0
                break
except Exception as e:
    print("hit exception")
    print(e)
    conn.close()

end = time.time()
spi.close()
print(count, "frames in", end-start, "seconds. FPS of", count/(end-start))
