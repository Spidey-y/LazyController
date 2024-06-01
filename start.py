import socket
import subprocess
import sys
import os


def get_ip():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    return ip_address


def get_valid_port():
    for port in range(5000, 65535):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex(('localhost', port))
        sock.close()
        if result != 0:
            return port
    return None


ip_address = get_ip()
port = get_valid_port()
print("\033[1;36m" +
      f"📱 To use LazyController, go to: http://{ip_address}:{port+1}" + "\033[0m")
print("\nPS: don't close this terminal, it's running the server.\n")
p = [subprocess.Popen(["uvicorn", "Server.app:app", f"--port={str(port)}", "--host=0.0.0.0", "--log-level=error"]),
     subprocess.Popen([sys.executable, 'flutter_server.py', str(port+1)], stdout=subprocess.DEVNULL,
                      stderr=subprocess.STDOUT)]
try:
    for process in p:
        process.wait()
    sys.stdout.flush()
except KeyboardInterrupt:
    for process in p:
        process.kill()
        process.wait()
    print("Server stopped.")
    sys.exit(0)
