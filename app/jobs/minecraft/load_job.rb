module Minecraft
  class LoadJob < ApplicationJob
    def perform(server, backup)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      SaveJob.perform_now(server) if server.world.present?

      minecraft = Docker::Container.get('minecraft')
      minecraft.stop

      FileUtils.mv("#{data_dir}/world", "#{data_dir}/world.#{Time.now.to_i}")

      if backup.file.present?
        backup.file.open do |file|
          ZipUtils.unzip(file, data_dir)
        end
      else
        FileUtils.mkdir("#{data_dir}/world")
      end

      server.update!(backup: backup)

      minecraft.start

      nil
    end
  end
end
