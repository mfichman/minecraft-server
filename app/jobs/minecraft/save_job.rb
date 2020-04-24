module Minecraft
  class SaveJob < ApplicationJob
    def perform(server)
      CommandJob.perform_now(server, "/save-all")
      CommandJob.perform_now(server, "/save-off")

      sleep(2) # FIXME

      file = Tempfile.new('tmp')
      file.close

      system("docker cp minecraft:/minecraft/data/world - > #{file.path}", exception: true)

      backup = server.world.backups.build
      backup.file.attach(io: file.open, filename: 'world.tar.gz', identify: false)
      backup.save!

      file.close
      file.unlink

      CommandJob.perform_now(server, "/save-on")

      nil
    end
  end
end


