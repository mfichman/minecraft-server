module Minecraft
  class ShutdownJob < ApplicationJob
    def perform(user, server)
      ToastsChannel.broadcast_to(user, ShutdownsController.render(partial: 'info'))
      server.logs.create!(text: "[Controller] Shutting down\n")

      delete_droplet(server)

      ToastsChannel.broadcast_to(user, ShutdownsController.render(partial: 'success'))
      server.logs.create!(text: "[Controller] Shutdown complete\n")
    rescue => e
      ToastsChannel.broadcast_to(user, ShutdownsController.render(partial: 'error', locals: { message: e.message }))
      server.logs.create!(text: "[Controller] Shutdown error: #{e.message}\n")
      raise
    end

    def delete_droplet(server)
      droplet = client.droplets.all.find { |d| d.name == server.host }
      return if droplet.nil?

      client.droplets.delete(id: droplet.id)
    end

    def delete_domain_record(server)
      domain_record = client.domain_records.all(for_domain: server.domain).find do |r|
        r.name == server.subdomain
      end

      return if domain_record.nil?

      client.domain_records.delete(for_domain: server.domain, id: domain_record.id)
    end

    def client
      @client ||= DropletKit::Client.new(access_token: access_token)
    end

    def access_token
      @access_token ||= Rails.application.credentials.dig(:digitalocean, :access_token)
    end
  end
end
