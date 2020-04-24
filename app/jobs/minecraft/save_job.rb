require_dependency('zip')

module Minecraft
  class SaveJob < ApplicationJob

    def zip(io, dir, prefix)
      Zip::File.open_buffer(io) do |zf|
        Dir[File.join(dir, prefix, '**', '**')].each do |file|
          zf.add(file.sub("#{dir}/", ''), file)
        end
      end
    end

    def perform(server)
      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      #CommandJob.perform_now(server, "/save-all")
      #CommandJob.perform_now(server, "/save-off")

      #sleep(5) # FIXME

      file = Tempfile.new('tmp')

      zip(file, data_dir, 'world')

      #system("tar -czvf #{file.path} -C #{data_dir} world", exception: true)
      #system("docker cp minecraft:/minecraft/data/world - > #{file.path}", exception: true)

      file.open

      backup = server.world.backups.build
      backup.file.attach(io: file, filename: 'world.tar.gz', identify: false)
      backup.save!

      file.close
      file.unlink

      #CommandJob.perform_now(server, "/save-on")

      nil
    end
  end
end


