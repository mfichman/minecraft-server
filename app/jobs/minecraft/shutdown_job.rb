module Minecraft
  class ShutdownJob < ApplicationJob
    def perform(user, server)
      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'info'))

      delete_droplet(server)

      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'success'))
    rescue => e
      ToastsChannel.broadcast_to(user, BootsController.render(partial: 'error', locals: { message: e.message }))
      raise
    end

    def delete_droplet(server)
      droplet = client.droplets.all.find { |d| d.name == server.host }
      return if droplet.nil?

      client.droplets.delete(id: droplet.id)
    end
  end
end
