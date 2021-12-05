class Minecraft::Jar < ApplicationRecord
  validates :version, presence: true
  validates :url, presence: true, url: true
end
