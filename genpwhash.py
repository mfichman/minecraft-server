from passlib.hash import sha256_crypt
import sys

print(sha256_crypt.encrypt(sys.argv[1]))
