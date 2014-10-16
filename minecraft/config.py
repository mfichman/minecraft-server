import automaton as auto
import os
import bcrypt

minecraft = auto.metadata.Hash()
s3 = auto.metadata.Hash()
ssl = auto.metadata.Hash()

auto.metadata.default.minecraft = minecraft
auto.metadata.default.s3 = s3
auto.metadata.default.ssl = ssl

s3.accesskey = os.environ.get('S3_ACCESS_KEY', None)
s3.secretkey = os.environ.get('S3_SECRET_KEY', None)

ssl.cert = os.environ.get('SSL_CERT')
ssl.key = os.environ.get('SSL_KEY')

minecraft.user = 'minecraft'
minecraft.version = '1.8'
minecraft.webport = 8080
minecraft.webpw = bytes(os.environ.get('WEB_PASSWORD', None))
minecraft.webpwhash = bcrypt.hashpw(minecraft.webpw, bcrypt.gensalt())
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

