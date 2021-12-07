class Minecraft::Modder < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :version}
  validates :version, presence: true
  validates :url, presence: true, url: true

  def file_name
    "#{name.parameterize}-#{version.underscore}.jar"
  end
end
