module Minecraft
  class BootJob < ApplicationJob
    def perform(user, server)
      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'info'))

      droplet = create_droplet(server)
      create_domain_record(server, droplet)

      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'success'))
    rescue => e
      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'error', locals: { message: e.message }))
      raise
    end

    def create_droplet(server)
      droplet = client.droplets.all.find { |d| d.name == server.host }
      return droplet if droplet

      cloud_config = cloud_config_for(server)

      volume = create_volume(server)

      droplet = DropletKit::Droplet.new(
        name: server.host,
        region: 'nyc1',
        size: 's-1vcpu-2gb',
        image: 'rancheros', # docker-20-04
        ssh_keys: ssh_keys,
        user_data: cloud_config,
        volumes: [volume.id]
      )

      client.droplets.create(droplet)
    end

    def create_domain_record(server, droplet)
      domain_record = client.domain_records.all(for_domain: server.domain).find do |r|
        r.name == server.subdomain
      end

      while (droplet = client.droplets.find(id: droplet.id)).networks[:v4].blank?
        sleep 1
      end

      ip_address = droplet.networks[:v4].first.ip_address
      id = domain_record&.id

      domain_record = DropletKit::DomainRecord.new(
        name: server.subdomain,
        ttl: 1.minute,
        data: ip_address,
        type: 'A'
      )

      if id
        client.domain_records.update(domain_record, for_domain: server.domain, id: id)
      else
        client.domain_records.create(domain_record, for_domain: server.domain)
      end
    end

    def create_volume(server)
      volume = client.volumes.all.find { |v| v.name == server.volume }
      return volume if volume

      volume = DropletKit::Volume.new(
        name: server.volume,
        region: 'nyc1',
        size_gigabytes: 10,
        filesystem_type: 'ext4'
      )

      client.volumes.create(volume)
    end

    def cloud_config_for(server)
      ServersController.render('cloud_config.yml', assigns: { server: server })
    end

    def ssh_keys
      @ssh_keys ||= client.ssh_keys.all.map(&:id)
    end

    def client
      @client ||= DropletKit::Client.new(access_token: access_token)
    end

    def access_token
      @access_token ||= Rails.application.credentials.dig(:digitalocean, :access_token)
    end
  end
end
