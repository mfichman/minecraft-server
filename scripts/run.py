import subprocess
import shlex
import os

null = open(os.devnull, 'w')
ret = subprocess.call(shlex.split('docker inspect minecraft'), stdout=null, stderr=null)
if ret == 1:
    subprocess.call(shlex.split('docker --tls run -it --name=minecraft --env-file env.list -p 8080:443 -p 25565:25565 mfichman/minecraft'))
else:
    subprocess.call(shlex.split('docker start minecraft'))
