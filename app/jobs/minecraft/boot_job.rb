module Minecraft
  class BootJob < ApplicationJob
    def perform(user, server)
      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'info'))
      server.logs.create!(text: "Booting\n")

      droplet = create_droplet(server)
      create_domain_record(server, droplet)

      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'success'))
      server.logs.create!(text: "Booted\n")
      server.update!(last_active_at: Time.now.utc)
    rescue => e
      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'error', locals: { message: e.message }))
      server.logs.create!(text: "Boot error: #{e.message}\n")
      raise
    end

    def create_droplet(server)
      droplet = client.droplets.all.find { |d| d.name == server.host }
      return droplet if droplet

      cloud_config = cloud_config_for(server)

      volume = create_volume(server)
      firewall = create_firewall

      droplet = DropletKit::Droplet.new(
        name: server.host,
        region: 'nyc1',
        # size:	g-2vcpu-8gb $60/mo 
        size: 'c-2',
        #image: 'rancheros',
        #size: 's-1vcpu-1gb',
        image: 'docker-20-04',
        ssh_keys: ssh_keys,
        user_data: cloud_config,
        volumes: [volume.id],
        firewalls: [firewall],
      )

      client.droplets.create(droplet)
    end

    def create_inbound_rules
      addresses = ['0.0.0.0/0', '::/0']
      [
        DropletKit::FirewallInboundRule.new(
          protocol: 'tcp',
          ports: '22',
          sources: {addresses: addresses}
        ),
        DropletKit::FirewallInboundRule.new(
          protocol: 'udp',
          ports: '51820',
          sources: {addresses: addresses}
        ),
      ]
    end

    def create_outbound_rules
      addresses = ['0.0.0.0/0', '::/0']

      [
        DropletKit::FirewallOutboundRule.new(
          protocol: 'tcp',
          ports: '0',
          destinations: {addresses: addresses}
        ),
        DropletKit::FirewallOutboundRule.new(
          protocol: 'udp',
          ports: '0',
          destinations: {addresses: addresses}
        ),
        DropletKit::FirewallOutboundRule.new(
          protocol: 'icmp',
          ports: '0',
          destinations: {addresses: addresses}
        ),
      ]
    end

    def create_firewall
      firewall = client.firewalls.all.find { |f| f.name == 'minecraft' }
      id = firewall&.id

      firewall = DropletKit::Firewall.new(
        name: 'minecraft',
        tags: [],
        droplet_ids: firewall&.droplet_ids || [],
        inbound_rules: create_inbound_rules,
        outbound_rules: create_outbound_rules,
      )

      if id
        client.firewalls.update(firewall, id: id)
      else
        client.firewalls.create(firewall)
      end
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
      # FIXME: Find a better way to do this; maybe delegate to vpn.mfichman.net
      network = Wireguard::Network.find_by!(host: server.host)
      ServersController.render('cloud_config', assigns: { server: server, network: network })
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
