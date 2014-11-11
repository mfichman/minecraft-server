set -e
docker --tls run --name minecraft --env-file env.list -p 8080:443 -p 25565:25565 minecraft 
