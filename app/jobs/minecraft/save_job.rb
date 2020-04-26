require_dependency('zip')

module Minecraft
  class SaveJob < ApplicationJob
    def perform(server)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      file = MinecraftUtils.save(data_dir)

      backup = server.world.backups.build
      backup.file.attach(io: file, filename: 'world.tar.gz', identify: false)
      backup.save!
    ensure
      file.close
    end
  end
end


