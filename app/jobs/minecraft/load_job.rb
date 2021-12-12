module Minecraft
  class LoadJob < ApplicationJob
    def perform(user, server, backup)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'
      server.logs.create!(text: "Loading\n")

      SaveJob.perform_now(user, server, autosave: true) if server.world.present?

      ToastsChannel.broadcast_to(user, LoadsController.render(partial: 'info'))

      install_args = server.slice(:mods, :jar, :modder, :properties, :ops).symbolize_keys

      if backup.file.present?
        backup.file.open do |file| 
          Minecraft::Utils.load(data_dir, file, **install_args)
        end
      else
        Minecraft::Utils.new(data_dir, **install_args)
      end

      server.update!(backup: backup)

      ToastsChannel.broadcast_to(user, LoadsController.render(partial: 'success'))
      server.logs.create!(text: "Loaded\n")
    rescue => e
      server.update!(backup: nil)
      ToastsChannel.broadcast_to(user, LoadsController.render(partial: 'error', locals: { message: e.message }))
      server.logs.create!(text: "Load error: #{e.message}\n")
      raise
    end
  end
end
