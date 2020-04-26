module Minecraft
  class LoadJob < ApplicationJob
    def perform(server, backup)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      SaveJob.perform_now(server) if server.world.present?

      if backup.file.present?
        backup.file.open { |file| MinecraftUtils.load(data_dir, file) }
      else
        MinecraftUtils.new(data_dir)
      end

      server.update!(backup: backup)
    end
  end
end
