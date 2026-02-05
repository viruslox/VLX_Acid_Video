import http.server
import socketserver

PORT = 8000

class AcidHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Prevent caching for live video updates
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

if __name__ == "__main__":
    with socketserver.ThreadingTCPServer(("", PORT), AcidHandler) as httpd:
        print(f"Acid_video Server: http://localhost:{PORT}")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
            httpd.server_close()
