#!/usr/bin/env python3
"""Serve the Flutter QA build locally without retaining stale JS/assets."""
import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


class PreviewHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, max-age=0')
        super().end_headers()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', type=int, default=8766)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1] / 'build' / 'web'
    if not (root / 'index.html').is_file():
        parser.error('Run flutter build web --release first.')
    server = ThreadingHTTPServer(
        ('127.0.0.1', args.port), partial(PreviewHandler, directory=str(root))
    )
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
