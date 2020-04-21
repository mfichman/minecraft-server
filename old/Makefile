HOST=rancher@167.99.154.35
SSH=ssh $(HOST)
SCP=scp
PASSWORD_HASH=$(shell python scripts/genpwhash.py $(PASSWORD))

build:
	docker build \
		--tag mfichman/minecraft .

machine:
	docker run \
		--interactive \
		--env DIGITALOCEAN_ACCESS_TOKEN=\'$(DIGITALOCEAN_ACCESS_TOKEN)\' \
	 	digitalocean/doctl compute droplet create minecraft \
		--image rancheros \
		--region nyc1 \
		--size s-1vcpu-2gb \
		--ssh-keys '$(SSH_KEY)'

install:
	$(SCP) -r letsencrypt $(HOST):

run:
	$(SSH) docker run \
		--name minecraft \
		--interactive \
		--volume ~/letsencrypt/live/minecraft.mfichman.net/fullchain.pem:/minecraft/cert.pem \
		--volume ~/letsencrypt/live/minecraft.mfichman.net/privkey.pem:/minecraft/key.pem \
		--env S3_ACCESS_KEY=\'$(S3_ACCESS_KEY)\' \
		--env S3_SECRET_KEY=\'$(S3_SECRET_KEY)\' \
		--env PASSWORD_HASH=\'$(PASSWORD_HASH)\' \
		--publish 443:443 \
		--publish 25565:25565 \
		mfichman/minecraft

certs:
	$(SSH) docker run \
		--name certbot \
		--publish 80:80 \
		--interactive \
		--volume /etc/letsencrypt:/etc/letsencrypt \
		certbot/certbot certonly \
		--standalone \
		--domains minecraft.mfichman.net \
		--agree-tos \
		-m matt.fichman@gmail.com \
		-n

.PHONY: run image
