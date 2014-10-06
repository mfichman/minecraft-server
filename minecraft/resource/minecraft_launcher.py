#!/usr/bin/env python

import bottle 
import subprocess
import shlex
import time
import datetime
import os
import sys
import signal
import threading
import argparse
import minecraft_s3
import json

minecraft_server_lock = threading.Lock()
minecraft_server = None

def stop():
    """Stop the server"""
    try:
        minecraft_server.kill()
    except:
        pass

def start():
    """Start the server"""
    global minecraft_server
    minecraft_cmd = shlex.split('java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui')
    minecraft_server = subprocess.Popen(minecraft_cmd, stdin=subprocess.PIPE)

@bottle.get('/')
def index():
    return bottle.static_file('index.html', root='.')

@bottle.get('/app.js')
def index():
    return bottle.static_file('app.js', root='.')

@bottle.get('/log')
def log():
    """Open the log and show the last N lines of it"""
    bottle.response.content_type = 'application/json'
    return '"%s"' % open('logs/latest.log').read().replace('\n', '\\n')

@bottle.post('/world/save')
def save():
    """Turn off auto-saving, and then upload the file to S3."""
    with minecraft_server_lock:
        minecraft_server.stdin.write('/save-off\n') 
        minecraft_server.stdin.write('/save-all\n')
        minecraft_server.stdin.flush()
        time.sleep(5)
        try:
            now = datetime.datetime.now().isoformat()
            minecraft_s3.pack()
            minecraft_s3.upload(now)
            return '<pre>saved: %s</pre>' % now
        finally:
            minecraft_server.stdin.write('/save-on\n')
            minecraft_server.stdin.flush()

@bottle.get('/world/saves')
def saves():
    """Get list of saved files from S3."""
    bottle.response.content_type = 'application/json'
    return json.dumps(list(reversed(sorted(minecraft_s3.all()))))
  
@bottle.post('/world/active')
def load():
    with minecraft_server_lock:
        if minecraft_server:
            minecraft_server.stdin.write('/save-off\n') 
            minecraft_server.stdin.write('/save-all\n')
            minecraft_server.stdin.flush()
            time.sleep(5)
            stop()
            subprocess.call(('mv', 'world', 'world.backup'))
        name = bottle.request.body.read()
        minecraft_s3.download(name)
        minecraft_s3.unpack()
        start()
    return '"ok"'

def sigterm(signum, frame):
    """Exit the service gracefully"""
    stop()
    sys.exit(0)

app = bottle.default_app()

def main():
    """Execute the launcher & web app monitor"""

    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=8080)
    args = parser.parse_args()
    try:
        bottle.run(host='0.0.0.0', port=args.port, debug=True, use_reloader=False)
    finally:
        stop()

if __name__ == '__main__':
    main()

