from passlib.hash import sha256_crypt
import sys

print(sha256_crypt.hash(sys.argv[1]))
