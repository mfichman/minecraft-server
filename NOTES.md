

# Web Server:
docker run -p 3000:3001 -e RAILS_MASTER_KEY=1c728e25cd18a967ef4eefbbf28c331f -it 760c04bdc3c6
cd images/slug && docker build --net=host .
