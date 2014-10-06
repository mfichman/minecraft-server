import zipfile
import tinys3
import os
import time
import sys
import argparse

s3_access_key = os.environ['S3_ACCESS_KEY']
s3_secret_key = os.environ['S3_SECRET_KEY']
s3_bucket = os.environ.get('S3_BUCKET', 'mfichman-minecraft')

def connection():
    return tinys3.Connection(s3_access_key, s3_secret_key, tls=True)

# Get all saves
def all():
    conn = connection()
    return [item['key'] for item in conn.list('', s3_bucket)]

# Get the latest
def latest():
    conn = connection()
    latest = ""
    for item in conn.list('', s3_bucket):
        if item['key'] > latest:
            latest = item['key']
    return latest

def pack():
    zf = zipfile.ZipFile('world.zip', 'w')
    for root, dirs, files in os.walk('world'):
        for name in files:
            zf.write(os.path.join(root, name))
    zf.close()

def upload(url):
    sys.stdout.write('uploading %s\n' % url)
    sys.stdout.flush()
    conn = connection()
    fd = open('world.zip', 'rb')
    conn.upload(url, fd, s3_bucket)
    fd.close()

def download(url):
    sys.stdout.write('downloading %s\n' % url)
    sys.stdout.flush()
    conn = connection()
    fd = open('world.zip', 'wb')
    resp = conn.get(url, s3_bucket)
    for block in resp.iter_content(16384):
        if not block:
            break
        fd.write(block)
    fd.close()

def unpack():
    zf = zipfile.ZipFile('world.zip', 'r')
    zf.extractall()

def main():
    # Download the latest game save, unpack it, then start the server
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest='command')
    
    sub = subparsers.add_parser('upload')
    sub.add_argument('url', type=str)

    sub = subparsers.add_parser('download')
    sub.add_argument('url', nargs='?', type=str)

    args = parser.parse_args()
    
    if args.command == 'upload':
        pack()
        upload(args.url)
    elif args.command == 'download':
        url = args.url or latest()
        if url:
            download(url)
            unpack()
        else:
            sys.stderr.write('couldn\'t find any world to download')
            sys.stderr.flush()
    else:
        assert(False)

if __name__ == '__main__':
    main()


