module Minecraft
  class LoadJob < ApplicationJob
    def perform(user, server, backup)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      SaveJob.perform_now(user, server, autosave: true) if server.world.present?

      ToastsChannel.broadcast_to(user, LoadsController.render(partial: 'info'))

      if backup.file.present?
        backup.file.open { |file| Minecraft::Utils.load(data_dir, file) }
      else
        Minecraft::Utils.new(data_dir)
      end

      server.update!(backup: backup)

      ToastsChannel.broadcast_to(user, LoadsController.render(partial: 'success'))
    rescue => e
      server.update!(backup: nil)
      ToastsChannel.broadcast_to(user, LoadsController.render(partial: 'error', locals: { message: e.message }))
      raise
    end
  end
end
