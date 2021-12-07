class Minecraft::Server < ApplicationRecord
  DEFAULT_JAR_URL = 'https://launcher.mojang.com/v1/objects/3cf24a8694aca6267883b17d934efacc5e44440d/server.jar'
  DEFAULT_JAR_VERSION = '1.18'

  belongs_to :backup, optional: true
  belongs_to :jar, optional: true
  belongs_to :modder, optional: true

  has_many :logs
  has_many :commands
  has_and_belongs_to_many :mods

  has_one :world, through: :backup

  validates :host, presence: true
  
  def volume
    host.parameterize
  end

  def subdomain
    host.split('.')[0...-2].join('.')
  end

  def domain
    host.split('.')[-2...].join('.')
  end

  def jar_url
    jar&.url || DEFAULT_JAR_URL
  end

  def jar_version
    jar&.version || DEFAULT_JAR_VERSION
  end
end

# https://maven.minecraftforge.net/net/minecraftforge/forge/1.18-38.0.15/forge-1.18-38.0.15-installer.jar
# Balm: https://media.forgecdn.net/files/3550/130/balm-2.1.1%2B0.jar 
# Waystones: https://media.forgecdn.net/files/3548/808/waystones-forge-1.18-9.0.0.jar
