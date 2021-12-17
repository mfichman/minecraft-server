module Minecraft
  module Utils
    extend FileUtils

    def self.run(command)
      puts "Running RCON command: #{command}"
      client = Rcon::Client.new(host: '127.0.0.1', port: 25575, password: 'foobar')
      begin
        client.authenticate!(ignore_first_packet: false)
        client.execute(command).body
      ensure
        client.end_session!
      end
    rescue Exception => e
      "[Controller] #{e.message}"
    end

    def self.save(data_dir)
      run('save-all') # Ensure changes are flushed
      run('save-off') # Avoid updates while snapshotting the world

      save_dir = "#{data_dir}/saves/current"

      rm_f('world.zip')

      ZipUtils.zip('world.zip', save_dir, 'world')
      File.open('world.zip', 'rb')
    ensure
      run('save-on')
    end

    def self.download(dir, file)
      return if file.nil?

      path = "#{dir}/#{file.file_name}"

      return if File.exists?(path)

      mkdir_p(dir)

      URI.open(file.url) do |stream|
        puts "Downloading #{file.file_name}"
        IO.copy_stream(stream, path)
      end
    end

    def self.install(data_dir, save_dir, mods:, jar:, modder:, properties:, ops:)
      install_digest = Digest::SHA256.hexdigest({mods: mods, jar: jar, modder: modder}.to_json)

      install_dir = "#{data_dir}/installs/#{install_digest}"
      cache_dir = "#{data_dir}/cache"
      run_dir = "#{data_dir}/run"

      download("#{cache_dir}/jars", jar)
      download("#{cache_dir}/modders", modder)
      mods.each {|mod| download("#{cache_dir}/mods", mod)}

      properties = properties.merge(
        'level-name' => save_dir,
        'server-port' => '25565',
        'server-ip' => '',
        'rcon.port' => '25575',
        'rcon.password' => 'foobar',
        'enable-rcon' => 'true',
      )

      mkdir_p(install_dir)
      rm_rf(run_dir)
      ln_sf(install_dir, run_dir)

      cd(run_dir) do
        ln_sf("#{cache_dir}/jars/#{jar.file_name}", 'minecraft_server.jar') if jar
        ln_sf("#{cache_dir}/modders/#{modder.file_name}", 'modder.jar')  if modder
        mkdir_p('mods')
        mods.each {|mod| ln_sf("#{cache_dir}/mods/#{mod.file_name}", "mods/#{mod.file_name}")}
        File.write("server.properties", properties.map {|key, value| "#{key}=#{value}"}.join("\n"))
        File.write("ops.txt", ops.join("\n"))
        File.write("eula.txt", "eula=true\n")
        File.write("user_jvm_args.txt", "-Xmx2G -Xms2G\n")
      end
    end

    def self.new(data_dir, **install_args)
      save_dir = "#{data_dir}/saves/#{Time.now.to_i}/world"
      mkdir_p(save_dir)
      rm_rf("#{data_dir}/saves/current")
      ln_sf(save_dir, "#{data_dir}/saves/current")

      install(data_dir, save_dir, **install_args)

      minecraft = Docker::Container.get('minecraft')
      minecraft.restart
    end

    def self.load(data_dir, file, **install_args)
      save_dir = "#{data_dir}/saves/#{Time.now.to_i}/world"
      ZipUtils.unzip(file, File.dirname(save_dir))
      rm_rf("#{data_dir}/saves/current")
      ln_sf(save_dir, "#{data_dir}/saves/current")

      install(data_dir, save_dir, **install_args)

      minecraft = Docker::Container.get('minecraft')
      minecraft.restart
    end

    def self.logs(since:, &block)
      time = since ? since.to_i : 0

      while true
        begin
          puts "Connecting to Minecraft server output"

          minecraft = Docker::Container.get('minecraft')
          minecraft.streaming_logs(stdout: true, stderr: true, since: time, follow: true) do |stream, chunk|
            yield chunk
          end

          sleep 1
        rescue Docker::Error::TimeoutError
        end

        time = Time.now.to_i
      end
    end
  end
end
