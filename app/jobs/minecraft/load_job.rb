require_dependency('zip')

module Minecraft
  class LoadJob < ApplicationJob

    def unzip(name, dir)
      Zip::File.open(name) do |zf|
        zf.each do |entry|
          entry.extract(File.join(dir, entry.name))
        end
      end
    end

    def perform(server, backup)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      SaveJob.perform_now(server)

      minecraft = Docker::Container.get('minecraft')
      minecraft.stop

      FileUtils.mv("#{data_dir}/world", "#{data_dir}/world.#{Time.now.to_i}")

      backup.file.open do |file|
        unzip(file.path, data_dir)
      end

      server.update!(backup: backup)

      minecraft.start

      nil
    end
  end
end
