module Minecraft
  module ServersHelper
    include BackupsHelper

    def cloud_config_service_files
      Dir[Rails.root.join('services', '*.yml')].map do |path|
        puts path
        {
          path: "/root/#{File.basename(path)}",
          permissions: '0644',
          content: File.read(path)
        }
      end
    end

    def cloud_config_wireguard_files
      [
        # FIXME: Load this dynamically on a per-server basis via API request to vpn.mfichman.net
        {
          path: '/etc/wireguard/wg0.conf',
          permissions: '0644',
          content: <<~EOF
            [Interface]
            Address = 10.25.0.8/32
            PrivateKey = #{Rails.application.credentials.wireguard[:private_key]}

            [Peer]
            PublicKey = #{Rails.application.credentials.wireguard[:public_key]}
            AllowedIPs = 10.25.0.0/24
            Endpoint = vpn.mfichman.net:51820
          EOF
        },
        {
          path: '/etc/wireguard/wg1.conf',
          permissions: '0644',
          content: Wireguard::NetworksController.render('show', formats: [:conf], assigns: { network: @network })
        },
      ]
    end

    def cloud_config_scripts
      [
        {
          path: '/root/.env',
          permissions: '0644',
          content: <<~EOF
            SERVER_NAME=#{@server.host}
            RAILS_MASTER_KEY=#{Figaro.env.rails_master_key}
            REDIS_URL=#{Figaro.env.redis_url}
            DATABASE_URL=#{Figaro.env.database_url}
          EOF
        },
        {
          path: '/root/up.sh',
          permissions: '0755',
          content: <<~EOF
            #!/usr/bin/env bash
            docker-compose --project-directory=/root --env-file=/root/.env -f/root/worker.yml -f/root/logger.yml -f/root/minecraft.yml up -d
          EOF
        },
        {
          path: '/root/down.sh',
          permissions: '0755',
          content: <<~EOF
            #!/usr/bin/env bash
            docker-compose --project-directory=/root --env-file=/root/.env -f/root/worker.yml -f/root/logger.yml -f/root/minecraft.yml down
          EOF
        },
      ]
    end

    def cloud_config_files
      [  
        *cloud_config_wireguard_files,
        *cloud_config_scripts,
        *cloud_config_service_files,
      ]
    end

    def cloud_config_runcmds
      [
        'ufw allow 51820/udp',
        'mkdir -p /volumes',
        "mkfs.ext4 /dev/disk/by-id/scsi-0DO_Volume_#{@server.volume}",
        "mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_#{@server.volume} /volumes",
        'systemctl enable wg-quick@wg0.service',
        'systemctl start wg-quick@wg0.service',
        'systemctl enable wg-quick@wg1.service',
        'systemctl start wg-quick@wg1.service',
        'curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose',
        'chmod +x /usr/local/bin/docker-compose',
        '/root/up.sh',
      ]
    end

    def cloud_config_yaml
      YAML.dump({
        mounts: ["/dev/disk/by-id/scsi-0DO_Volume_#{@server.volume}", '/volumes', 'ext4', 'discard,noatime'],
        package_update: true,
        packages: ['wireguard-tools', 'curl', 'haveged'],
        write_files: cloud_config_files,
        runcmd: cloud_config_runcmds
      }.deep_stringify_keys)
    end
  end
end
