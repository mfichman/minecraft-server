local auto = require('automaton')
local minecraft = {}
local s3 = {}
local ssh = {}

auto.metadata.override.minecraft = minecraft
auto.metadata.override.s3 = s3
auto.metadata.override.ssh = ssh

ssh.host = '127.0.0.1'
ssh.port = 2222
ssh.privatekey = 'C:/Users/Matt/.vagrant.d/insecure_private_key'
ssh.user = 'vagrant'

minecraft.ops = {'mfichman'}
minecraft.savename = ''
minecraft.options = {}
minecraft.options.motd = 'WASSUP YA DINGUS'
minecraft.options.onlinemode = true

s3.accesskey = os.getenv('S3_ACCESS_KEY')
s3.secretkey = os.getenv('S3_SECRET_KEY')

