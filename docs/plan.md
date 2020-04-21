# Config

config/services
    - wireguard.yml: Wireguard service
    - minecraft.yml: Minecraft service
    - web.yml: Console web service
    - cloud-init.yml: Configuration for server


# Other

- Use sqlite for database
- Use S3/active storage for storage
- Use sucker_punch for async tasks

# Models

World
    - name

WorldBackup
    - world_id
    - attachment

ServerCommand
    - server_id
    - text

ServerLog
    - text
    - server_id

Server
    - name

/worlds/new
/worlds/index
/worlds/:id
/worlds/:id/backups

/server/

RunServerCommandJob
CreateWorldJob
CreateWorldBackupJob

# postgres.yml: Postgres service
# redis.yml: Redis sevice

