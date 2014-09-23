#!/usr/bin/env python

from flask import Flask, request, g, url_for, abort, render_template
import subprocess
import shlex
import time

app = Flask(__name__)
app.config.from_object(__name__)

minecraft_cmd = shlex.split('java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui')
server = subprocess.Popen(minecraft_cmd, stdin=subprocess.PIPE)

# Return the end of the app log.
@app.route('/log')
def log():
    return subprocess.check_output(shlex.split('tail -f -n 64 logs/latest.log'))

# Save the game and upload it to EC2. Temporarily pause auto-saving so that we
# get a consistent snapshot of the save file.
@app.route('/save')
def save():
    server.stdin.write('/save-off\n') 
    server.stdin.write('/save-all\n')
    server.stdin.flush()
    try:
        return subprocess.check_output(shlex.split('python minecraft-s3.py upload "%s"' % time.ctime()))
    except subprocess.CalledProcessError, e:
        return e.output
    finally:
        server.stdin.write('/save-on\n')
        server.stdin.flush()
    

@app.route('/')
def main():
    return app.send_static_file('index.html')

if __name__ == '__main__':
    app.run()
