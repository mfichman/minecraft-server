module MinecraftUtils

  def self.run(command)
    container = Docker::Container.get('minecraft')
    container.attach(stdin: StringIO.new("#{command}\n"))
  end

  def self.save(data_dir)
    file = Tempfile.new('tmp')
    run('/save-off')

    ZipUtils.zip(file, data_dir, 'world')

    file.open
    file
  ensure
    file.unlink
    run('/save-on')
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
        minecraft = Docker::Container.get('minecraft')
        minecraft.streaming_logs(stdout: true, stderr: true, since: time, tty: true, follow: true, &block)
      rescue Docker::Error::TimeoutError
      end

      time = Time.now.to_i
    end
  end
end
