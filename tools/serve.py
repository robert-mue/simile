#!/usr/bin/env python3
"""Serve this repository over http, with caching turned OFF.

    python3 tools/serve.py           # http://localhost:8731/index.html
    python3 tools/serve.py 9000      # a different port

WHY THIS EXISTS, since a plain `python3 -m http.server` looks identical:

`http.server` sends `Last-Modified` and nothing else — no `Cache-Control`, no
`ETag`. Chrome is then free to cache heuristically, and does, so the browser can
go on running a file that changed on disk minutes ago. That is not a theoretical
risk. On 2026-08-31 it produced, in one afternoon:

  - `test/fixtures.html` reporting "4 of 6 fixtures failed" with
    `Unknown node type "compartment"`, two days after that rename was finished
    and committed — the page was running the previous week's scripts;
  - a new equation-error dialog that appeared to do nothing at all, reported as
    a bug, chased through the model layer, and finally explained by the browser
    still holding the version of `dialog.js` from before it was written.

Both cost more time than this file will ever save, and both looked exactly like
real faults. A dev server that cannot serve a stale byte removes a whole class
of false result, and the app has no build step to invalidate anything for us.

Note that Ctrl+Shift+R is NOT a reliable escape: content widgets and dialogs are
injected as scripts at run time rather than listed in `index.html`, so a reload
that bypasses the cache for the page need not bypass it for them.

This is for development only. It is the standard library's simple server with
three headers added, and has no business anywhere near a real deployment.
"""

import functools
import http.server
import os
import sys

PORT = 8731
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # `no-store` is the strong one: not merely "revalidate before reuse" but
        # "do not keep a copy at all". Pragma/Expires are for anything older
        # sitting in between.
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

    def send_header(self, keyword, value):
        # Drop the validators the base class adds, so nothing downstream can use
        # them to justify a conditional request and a 304.
        if keyword.lower() in ('last-modified', 'etag'):
            return
        super().send_header(keyword, value)

    def log_message(self, fmt, *args):
        if '"GET' in (fmt % args) and ' 200 ' in (fmt % args):
            return                          # quiet: only errors are interesting
        super().log_message(fmt, *args)


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else PORT
    handler = functools.partial(NoCacheHandler, directory=ROOT)
    with http.server.ThreadingHTTPServer(('127.0.0.1', port), handler) as httpd:
        print('simile: serving %s' % ROOT)
        print('        http://localhost:%d/index.html' % port)
        print('        caching disabled — the browser always gets what is on disk')
        print('        Ctrl-C to stop')
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print('\nstopped')


if __name__ == '__main__':
    main()
