class Minecraft::Server < ApplicationRecord
  DEFAULT_JAR_URL = 'https://launcher.mojang.com/v1/objects/3cf24a8694aca6267883b17d934efacc5e44440d/server.jar'
  DEFAULT_JAR_VERSION = '1.18'

  belongs_to :backup, optional: true
  belongs_to :jar, optional: true

  has_many :logs
  has_many :commands

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
