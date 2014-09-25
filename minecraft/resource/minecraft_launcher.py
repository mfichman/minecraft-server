#!/usr/bin/env python

from flask import Flask, request, g, url_for, abort, render_template
import subprocess
import shlex
import time
import datetime
import os

app = Flask(__name__)
app.config.from_object(__name__)

minecraft_cmd = shlex.split('java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui')

# Return the end of the app log.
@app.route('/log')
def log():
    lines = open('logs/latest.log').readlines()
    return '<pre>%s</pre>' % ''.join(lines[-64:])

# Save the game and upload it to EC2. Temporarily pause auto-saving so that we
# get a consistent snapshot of the save file.
@app.route('/save')
def save():
    server.stdin.write('/save-off\n') 
    server.stdin.write('/save-all\n')
    server.stdin.flush()
    try:
        now = datetime.datetime.now().isoformat()
        subprocess.check_call(shlex.split('python minecraft_s3.py upload "%s"' % now))
        return '<pre>saved: %s</pre>' % now
    except subprocess.CalledProcessError, e:
        return '<pre>error: %s %s</pre>' % (str(e), e.output)
    finally:
        server.stdin.write('/save-on\n')
        server.stdin.flush()

def main():
    global server
    server = subprocess.Popen(minecraft_cmd, stdin=subprocess.PIPE)
    try:
        port = int(os.environ.get('MINECRAFT_HTTP_PORT', 8080))
        app.run(host='0.0.0.0', port=port, debug=True, use_reloader=False)
    finally:
        server.kill()

if __name__ == '__main__':
    main()

