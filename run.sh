set -e
#docker --tls run --name=minecraft -d --volume=/data debian true
docker --tls run -it --env-file env.list --volumes-from=minecraft -p 8080:443 -p 25565:25565 minecraft 
#docker --tls run -it --env-file env.list --volumes-from=minecraft -p 8080:443 -p 25565:25565 minecraft  /bin/bash
