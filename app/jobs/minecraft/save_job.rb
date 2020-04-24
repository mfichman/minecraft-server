require_dependency('zip')

module Minecraft
  class SaveJob < ApplicationJob
    def perform(server)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      CommandJob.perform_now(server, "/save-off")

      file = Tempfile.new('tmp')

      ZipUtils.zip(file, data_dir, 'world')

      file.open

      backup = server.world.backups.build
      backup.file.attach(io: file, filename: 'world.tar.gz', identify: false)
      backup.save!

      file.close
      file.unlink

      CommandJob.perform_now(server, "/save-on")

      nil
    end
  end
end


