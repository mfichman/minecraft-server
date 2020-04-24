class Minecraft::Server < ApplicationRecord
  belongs_to :backup, optional: true

  has_many :logs
  has_many :commands

  has_one :world, through: :backup

  validates :host, presence: true
end
