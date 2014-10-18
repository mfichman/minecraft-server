import automaton as auto
import os
from passlib.hash import sha256_crypt

minecraft = auto.metadata.Hash()
s3 = auto.metadata.Hash()
ssl = auto.metadata.Hash()

auto.metadata.default.minecraft = minecraft
auto.metadata.default.s3 = s3
auto.metadata.default.ssl = ssl

s3.accesskey = os.environ['S3_ACCESS_KEY']
s3.secretkey = os.environ['S3_SECRET_KEY']

ssl.cert = open('cert.pem', 'rb').read()
ssl.key = open('key.pem', 'rb').read()

minecraft.user = 'minecraft'
minecraft.version = '1.8'
minecraft.webport = 8080
minecraft.webpw = bytes(os.environ['WEB_PASSWORD'])
minecraft.webpwhash = sha256_crypt.encrypt(minecraft.webpw)
minecraft.ops = []
minecraft.options = auto.metadata.Hash()
minecraft.options.generatorsettings = ''
minecraft.options.allownether = True
minecraft.options.levelname = 'world'
minecraft.options.enablequery = False
minecraft.options.allowflight = False
minecraft.options.serverport = 25565
minecraft.options.leveltype = 'DEFAULT'
minecraft.options.enablercon = False
minecraft.options.levelseed = ''
minecraft.options.serverip = ''
minecraft.options.maxbuildheight = 256
minecraft.options.spawnnpcs = True
minecraft.options.whitelist = False
minecraft.options.spawnanimals = True
minecraft.options.snooperenabled = True
minecraft.options.hardcore = False
minecraft.options.texturepack = ''
minecraft.options.onlinemode = True
minecraft.options.pvp = True
minecraft.options.difficulty = 1
minecraft.options.gamemode = 0
minecraft.options.maxplayers = 20
minecraft.options.spawnmonsters = True
minecraft.options.generatestructures = True
minecraft.options.viewdistance = 10
minecraft.options.motd = 'Minecraft server'

