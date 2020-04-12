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
import s3
import json
import uuid
from passlib.hash import sha256_crypt

minecraft_server_lock = threading.Lock()
minecraft_server = None
session_id = None
password_hash = bytes(os.environ.get('PASSWORD_HASH'))

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

def authenticate(func):
    # Do not allow access unless authenticated
    def authenticate():
        if session_id != None and bottle.request.get_cookie('session_id') == session_id:
            return func()
        else:
            bottle.response.status = 403
            return json.dumps('access denied')
    return authenticate

@bottle.post('/session/new')
def session():
    # Create a new session
    global session_id
    password = bottle.request.json['password']

    if sha256_crypt.verify(password, password_hash):
        session_id = str(uuid.uuid1())
        bottle.response.set_cookie('session_id', session_id, httponly=True, path='/')
        return json.dumps('ok')
    else:
        bottle.response.status = 403
        return json.dumps('access denied')

@bottle.get('/')
def index():
    return bottle.static_file('launcher.html', root='.')

@bottle.get('/launcher.js')
def js():
    return bottle.static_file('launcher.js', root='.')

@bottle.get('/launcher.css')
def css():
    return bottle.static_file('launcher.css', root='.')

@bottle.post('/reboot')
@authenticate
def reboot():
    """Reboot the server"""
    bottle.response.content_type = 'application/json'
    stop()
    start()
    return json.dumps('ok')

@bottle.get('/log')
@authenticate
def log():
    """Open the log and show the last N lines of it"""
    bottle.response.content_type = 'application/json'
    try:
        return json.dumps(open('logs/latest.log').read())
    except:
        return json.dumps('')

@bottle.get('/world/saves')
@authenticate
def saves():
    """Get list of saved files from S3."""
    bottle.response.content_type = 'application/json'
    return json.dumps(list(reversed(sorted(s3.all()))))

@bottle.post('/world/save')
@authenticate
def save():
    """Turn off auto-saving, and then upload the file to S3."""
    with minecraft_server_lock:
        if minecraft_server:
            minecraft_server.stdin.write('/save-off\n')
            minecraft_server.stdin.write('/save-all\n')
            minecraft_server.stdin.flush()
            time.sleep(1) # FIXME
        try:
            name = bottle.request.json['name']
            now = datetime.datetime.now().isoformat()
            s3.pack()
            s3.upload('{}-{}'.format(name, now))
            return json.dumps(now)
        finally:
            if minecraft_server:
                minecraft_server.stdin.write('/save-on\n')
                minecraft_server.stdin.flush()
    return json.dumps('ok')

@bottle.post('/world/active')
@authenticate
def load():
    with minecraft_server_lock:
        if minecraft_server:
            minecraft_server.stdin.write('/save-off\n')
            minecraft_server.stdin.write('/save-all\n')
            minecraft_server.stdin.flush()
            time.sleep(1) # FIXME
            stop()
            now = datetime.datetime.now().isoformat()
            subprocess.call(('mv', 'world', 'world.backup.%s' % now))
        name = bottle.request.json
        s3.download(name)
        s3.unpack()
        start()
    return json.dumps('ok')

def sigterm(signum, frame):
    """Exit the service gracefully"""
    stop()
    sys.exit(0)

app = bottle.default_app()
bottle.debug(True)

start()

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

