class Minecraft::LoadJob < ApplicationJob
  def perform(server, backup)
    SaveJob.perform_now(server)

    container = Docker::Container.get('minecraft')
    container.stop

    backup.file.open do |file|
      system("tar -xzvf #{file.path} /data/world")
    end

    server.update!(backup: backup)

    container.start
  end
end
