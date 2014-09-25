# Copyright (c) 2014 Matt Fichman
#
# Permission is hereby granted, free of charge, to any person obtaining a 
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the 
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

import automaton as auto

username = auto.metadata.minecraft.user
homedir = '/home/%s' % username
version = auto.metadata.minecraft.version

# Install required packages
auto.Package('openjdk-7-jre')
auto.PythonPackage('tinys3')
auto.PythonPackage('bottle')

# Set up user and home directories for minecraft server
auto.User(username)

auto.Directory(
    homedir,
    owner=username,
    mode=0700,
)

auto.Directory(
    '%s/server' % homedir, 
    owner=username,
    mode=0700,
)

# Executable jar file
auto.File(
    '%s/server/minecraft_server.jar' % homedir,
    owner=username,
    mode=0700,
    content=auto.remote('https://s3.amazonaws.com/Minecraft.Download/versions/%s/minecraft_server.%s.jar' % (version, version)),
)

# Configuration files
auto.File(
    '%s/server/eula.txt' % homedir,
    owner=username,
    mode=0600,
    content='eula=true\n',
)

auto.File(
    '%s/server/ops.txt' % homedir,
    owner=username,
    mode=0600,
    content='\n'.join(auto.metadata.minecraft.ops),
)

auto.File(
    '%s/server/server.properties' % homedir,
    owner=username,
    mode=0600,
    content=auto.template('server.properties.t'),
)

auto.File(
    '/root/.bashrc',
    owner='root',
    mode=0400,
    content=auto.template('bashrc.t'),
)

# Support scripts
auto.File(
    '%s/server/minecraft_s3.py' % homedir,
    owner=username,
    mode=0700,
    content=auto.content('minecraft_s3.py'),
)

auto.File(
    '%s/server/minecraft_launcher.py' % homedir,
    owner=username,
    mode=0700,
    content=auto.content('minecraft_launcher.py'),
)

# Firewall entry for server port
auto.FirewallRule(
    action='accept',
    direction='input',
    port=auto.metadata.minecraft.options.serverport,
    protocol='tcp',
)

# Web interface port
auto.FirewallRule(
    action='accept',
    direction='input',
    port=auto.metadata.minecraft.webport,
    protocol='tcp',
)

# Set up minecraft service
auto.File(
    '%s/server/minecraft_server.sh' % homedir,
    owner=username,
    mode=0700,
    content=auto.template('minecraft_server.sh.t'),
)

auto.Daemon(
    'minecraft',
    command='bash minecraft_server.sh',
    workdir='%s/server' % homedir,
    user='minecraft',
)

