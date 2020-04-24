module Minecraft
  class LoadJob < ApplicationJob
    def perform(server, backup)
     # SaveJob.perform_now(server)

      minecraft = Docker::Container.get('minecraft')
      minecraft.stop

      system("docker run --volumes-from minecraft -it alpine mv /minecraft/data/world /minecraft/data/world.#{Time.now.iso8601}}", exception: true)

      backup.file.open do |file|
        system("docker cp - minecraft:/minecraft/data/ < #{file.path}", exception: true)
      end

      server.update!(backup: backup)

      minecraft.start

      nil
    end
  end
end
