class Minecraft::Server < ApplicationRecord
  belongs_to :backup, optional: true

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
end
