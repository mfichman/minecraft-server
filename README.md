minecraft-server
================

Runs a Minecraft server using Docker. Here's how to set it up:

```
docker run -it \
   --name=minecraft \
   --env=S3_ACCESS_KEY=? \
   --env=S3_SECRET_KEY=? \
   --env=PASSWORD_HASH=? \
   mfichman/minecraft

```

To copy the world out of the container, run:

```
docker exec minecraft zip -9r -C minecraft world.zip world
docker exec minecraft cat world.zip > world.zip
```
