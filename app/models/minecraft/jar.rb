class Minecraft::Jar < ApplicationRecord
  validates :version, presence: true
  validates :url, presence: true, url: true

  def file_name
    "server-#{version}.jar"
  end
end
