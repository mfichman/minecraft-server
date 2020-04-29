require_dependency('zip')

module ZipUtils
  def self.unzip(io, dir)
    Zip::File.open(io) do |zf|
      zf.each do |entry|
        entry.extract(File.join(dir, entry.name))
      end
    end
  end

  def self.zip(io, dir, prefix)
    Zip::File.open(io, Zip::File::CREATE) do |zf|
      Dir[File.join(dir, prefix, '**', '**')].each do |file|
        zf.add(file.sub("#{dir}/", ''), file)
      end
    end
  end
end
