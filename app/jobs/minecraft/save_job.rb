module Minecraft
  class SaveJob < ApplicationJob
    def perform(server)
      CommandJob.perform_now(server, "/save-all")
      CommandJob.perform_now(server, "/save-off")

      file = Tempfile.new('tmp')

      config = {
        'HostConfig' => { 'VolumesFrom' => ['minecraft'] },
        'Image' => 'busybox',
      }

      tar = Docker::Container.create(config.merge('Cmd' => %w(tar -czv /minecraft/data/world)))
      tar.start
      tar.attach(stdout: file)
      tar.remove

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

      #system("docker cp minecraft:/minecraft/data/world - > #{file.path}", exception: true)

