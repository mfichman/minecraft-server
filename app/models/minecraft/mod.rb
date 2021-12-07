class Minecraft::Mod < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :version}
  validates :version, presence: true
  validates :url, presence: true, url: true

  def to_s
    [name, version].join(' ')
  end

  def file_name
    "#{name.parameterize}-#{version.underscore}.jar"
  end
end
