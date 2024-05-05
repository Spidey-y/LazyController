import http.server
import socketserver
import sys
import os

os.chdir("./web")
handler = http.server.SimpleHTTPRequestHandler
handler.extensions_map.update({
    '.webapp': 'application/x-web-app-manifest+json',
})
print("Serving at port", sys.argv[1])
with socketserver.TCPServer(("", int(sys.argv[1])), handler) as httpd:
    print("Serving at port", sys.argv[1])
    httpd.serve_forever()
