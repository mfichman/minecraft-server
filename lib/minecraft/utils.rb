module Minecraft
  module Utils
    def self.run(command)
      container = Docker::Container.get('minecraft')
      container.attach(stdin: StringIO.new("#{command}\n"))
    end

    def self.save(data_dir)
      run('/save-off')

      FileUtils.rm_f('world.zip')

      ZipUtils.zip('world.zip', data_dir, 'world')

      File.open('world.zip', 'rb')
    ensure
      run('/save-on')
    end

    def self.download(dir, file)
      return if file.nil?

      path = "#{dir}/#{file.file_name}"

      return if File.exists?(path)

      FileUtils.mkdir_p(dir)

      URI.open(file.url) do |stream|
        puts "Installing #{file.file_name}"
        IO.copy_stream(stream, path)
      end
    end

    def self.link(data_dir, mods:, jar:, modder:)
      if jar.present?
        FileUtils.copy("cache/jars/#{jar.file_name}", 'minecraft_server.jar') 
      else
        FileUtils.rm_f('minecraft_server.jar')
      end

      if modder.present?
        FileUtils.copy("cache/modders/#{modder.file_name}", 'modder.jar') 
      else
        FileUtils.rm_f('modder.jar')
      end

      FileUtils.rm_f('mods')
      FileUtils.mkdir_p('mods')

      mods.each do |mod|
        FileUtils.copy("cache/mods/#{mod.file_name}", "mods/#{mod.file_name}")
      end
    end

    def self.install(data_dir, mods:, jar:, modder:)
      FileUtils.cd(data_dir) do
        download('cache/jars', jar)
        download('cache/modders', modder)
        mods.each {|mod| download('cache/mods', mod)}

        link(data_dir, mods: mods, jar: jar, modder: modder)
      end
    end

    def self.new(data_dir)
      minecraft = Docker::Container.get('minecraft')
      minecraft.stop if minecraft.info.dig('State', 'Status') == 'running'

      if Dir.exists?("#{data_dir}/world")
        FileUtils.mv("#{data_dir}/world", "#{data_dir}/world.#{Time.now.to_i}")
      end

      FileUtils.mkdir("#{data_dir}/world")
    ensure
      minecraft.start
    end

    def self.load(data_dir, file)
      minecraft = Docker::Container.get('minecraft')
      minecraft.stop if minecraft.info.dig('State', 'Status') == 'running'

      if Dir.exists?("#{data_dir}/world")
        FileUtils.mv("#{data_dir}/world", "#{data_dir}/world.#{Time.now.to_i}")
      end

      ZipUtils.unzip(file, data_dir)

      minecraft.start
    end

    def self.logs(since:, &block)
      time = since ? since.to_i : 0

      while true
        begin
          puts "Connecting to Minecraft server output"

          minecraft = Docker::Container.get('minecraft')
          minecraft.streaming_logs(stdout: true, stderr: true, since: time, tty: true, follow: true, &block)

          sleep 1
        rescue Docker::Error::TimeoutError
        end

        time = Time.now.to_i
      end
    end
  end
end
