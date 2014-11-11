openssl req -x509 -newkey rsa:2048 \
    -subj "/C=US/ST=Maryland/L=Annapolis/O=IT" \
    -keyout minecraft/key.pem \
    -out minecraft/cert.pem \
    -days 2048 \
    -nodes \
