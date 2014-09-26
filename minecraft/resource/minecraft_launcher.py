#!/usr/bin/env python

from bottle import route, get, post, run
import subprocess
import shlex
import time
import datetime
import os
import sys
import signal
import threading
import argparse

minecraft_server_lock = threading.Lock()

@route('/log')
def log():
    """Open the log and show the last N lines of it"""
    lines = open('logs/latest.log').readlines()
    return '<pre>%s</pre>' % ''.join(lines[-64:])

@route('/save')
def save():
    """Turn off auto-saving, and then upload the file to S3."""
    with minecraft_server_lock:
        minecraft_server.stdin.write('/save-off\n') 
        minecraft_server.stdin.write('/save-all\n')
        minecraft_server.stdin.flush()
        try:
            now = datetime.datetime.now().isoformat()
            subprocess.check_call(shlex.split('python minecraft_s3.py upload "%s"' % now))
            return '<pre>saved: %s</pre>' % now
        except subprocess.CalledProcessError, e:
            return '<pre>error: %s %s</pre>' % (str(e), e.output)
        finally:
            minecraft_server.stdin.write('/save-on\n')
            minecraft_server.stdin.flush()

def sigterm(signum, frame):
    """Exit the service gracefully"""
    sys.exit(0)

def main():
    """Execute the launcher & web app monitor"""
    global minecraft_server

    parser = argparse.ArgumentParser()
    parser.add_argument('url', nargs='?', type=str, default='')
    parser.add_argument('--port', type=int, default=8080)
    args = parser.parse_args()

    subprocess.call(shlex.split('python minecraft_s3.py download "%s"' % args.url))

    minecraft_cmd = shlex.split('java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui')
    minecraft_server = subprocess.Popen(minecraft_cmd, stdin=subprocess.PIPE)

    try:
        run(host='0.0.0.0', port=args.port, debug=True, use_reloader=False)
    finally:
        minecraft_server.kill()

if __name__ == '__main__':
    main()

