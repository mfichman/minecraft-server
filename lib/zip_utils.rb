require_dependency('zip')

module ZipUtils
  def self.unzip(io, dir)
    Zip::File.open(io) do |zf|
      zf.each do |entry|
        path = File.join(dir, entry.name)
        FileUtils.mkdir_p(File.dirname(path))
        entry.extract(path)
      end
    end
  end

  def self.zip(io, dir, prefix)
    Zip::File.open(io, Zip::File::CREATE) do |zf|
      Dir[File.join(dir, '**', '**')].each do |file|
        zf.add(file.sub(/^#{dir}/, prefix), file)
      end
    end
  end
end
