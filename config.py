import automaton as auto
import os

minecraft = auto.metadata.Hash()
s3 = auto.metadata.Hash()
ssh = auto.metadata.Hash()

auto.metadata.override.minecraft = minecraft
auto.metadata.override.s3 = s3
auto.metadata.override.ssh = ssh

ssh.host = '127.0.0.1'
ssh.port = 2222
ssh.privatekey = 'C:/Users/Matt/.vagrant.d/insecure_private_key'
ssh.user = 'vagrant'

minecraft.ops = {'mfichman'}
minecraft.savename = ''
minecraft.options = auto.metadata.Hash()
minecraft.options.motd = 'WASSUP YA DINGUS'
minecraft.options.onlinemode = True

s3.accesskey = os.environ.get('S3_ACCESS_KEY', None)
s3.secretkey = os.environ.get('S3_SECRET_KEY', None)

