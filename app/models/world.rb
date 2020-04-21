class World < ApplicationRecord
  has_many :world_backups

  validates :name, presence: true
end
