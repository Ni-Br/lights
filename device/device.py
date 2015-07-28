#Example imported from <https://docs.python.org/2/library/socketserver.html>
import socketserver
import time

class MyTCPHandler(socketserver.StreamRequestHandler):
    """
    The RequestHandler class for our server.

    It is instantiated once per connection to the server, and must
    override the handle() method to implement communication to the
    client.
    """
    def handle(self):
        #Frame to be displayed
        self.data = self.rfile.readline().strip()
        #toSpi(self.data)

        #Ask for the current frame
        self.wfile.write(str(time.time()).encode())

if __name__ == "__main__":
    #TODO configure this to some sane default (read from args?)
    HOST, PORT = "localhost", 9999

    # Create the server, binding to localhost on port 9999
    server = socketserver.TCPServer((HOST, PORT), MyTCPHandler)

    # Activate the server; this will keep running until you
    # interrupt the program with Ctrl-C
    server.serve_forever()
