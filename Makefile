build:
	docker build \
		--tag mfichman/minecraft .

run: key.pem
	docker run \
		--interactive \
		--tty \
		--volume $(shell pwd)/cert.pem:/minecraft/cert.pem \
		--volume $(shell pwd)/key.pem:/minecraft/key.pem \
		--name minecraft \
		--env-file env.list \
		--publish 8080:443 \
		--publish 25565:25565 \
		mfichman/minecraft

key.pem:
	openssl req \
		-x509 \
		-newkey rsa:2048 \
    	-subj "/C=US/ST=Maryland/L=Annapolis/O=IT" \
    	-keyout key.pem \
    	-out cert.pem \
    	-days 2048 \
    	-nodes


.PHONY: run image
