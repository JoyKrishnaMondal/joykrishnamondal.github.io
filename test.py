import socket


TCP_IP = '192.168.125.3'
TCP_PORT = 9761
BUFFER_SIZE = 1024
MESSAGE1 = b"02:63:82:00:06"
MESSAGE2 = b"02:63:82:80:06" 

print "hello"
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print "hello"
s.connect((TCP_IP, TCP_PORT))
print "hello"
s.send(MESSAGE1)
print "hello"
s.send(MESSAGE2)
print "hello"
s.close()
print "hello"