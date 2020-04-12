import zipfile
import os
import time
import sys
import argparse
import boto

s3_access_key = os.environ['S3_ACCESS_KEY']
s3_secret_key = os.environ['S3_SECRET_KEY']
s3_bucket = os.environ.get('S3_BUCKET', 'mfichman-minecraft')

def connection():
    return boto.connect_s3(
        aws_access_key_id=s3_access_key,
        aws_secret_access_key=s3_secret_key)

# Get all saves
def all():
    conn = connection()
    return [key.name for key in conn.get_bucket(s3_bucket).list()]

# Get the latest
def latest():
    conn = connection()
    latest = ""
    for name in all():
        if name > latest:
            latest = name
    return latest

def pack():
    zf = zipfile.ZipFile('world.zip', 'w', zipfile.ZIP_DEFLATED)
    for root, dirs, files in os.walk('world'):
        for name in files:
            zf.write(os.path.join(root, name))
    zf.close()

def upload(url):
    sys.stdout.write('uploading %s\n' % url)
    sys.stdout.flush()
    conn = connection()
    bucket = conn.get_bucket(s3_bucket)
    key = boto.s3.key.Key(bucket)
    key.key = url
    key.set_contents_from_filename('world.zip')
    sys.stdout.write('uploaded %s\n' % url)
    sys.stdout.flush()

def download(url):
    sys.stdout.write('downloading %s\n' % url)
    sys.stdout.flush()
    conn = connection()
    bucket = conn.get_bucket(s3_bucket)
    key = bucket.get_key(url)
    key.get_contents_to_filename('world.zip')
    sys.stdout.write('downloaded %s\n' % url)
    sys.stdout.flush()

def unpack():
    zf = zipfile.ZipFile('world.zip', 'r', zipfile.ZIP_DEFLATED)
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


