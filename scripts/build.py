import subprocess
import shlex

subprocess.call(shlex.split('docker build -t mfichman/minecraft .'))
