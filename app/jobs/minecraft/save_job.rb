module Minecraft
  class SaveJob < ApplicationJob
    def perform(server)
      CommandJob.perform_now(server, "/save-all")
      CommandJob.perform_now(server, "/save-off")

      file = Tempfile.new('tmp')

      system("tar -czvf #{file.path} /data/world")

      backup = server.world.backups.build
      backup.file.attach(io: file, filename: 'world.tar.gz', identify: false)
      backup.save!

      CommandJob.perform_now(server, "/save-on")
    end
  end
end
