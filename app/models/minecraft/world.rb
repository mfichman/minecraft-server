class Minecraft::World < ApplicationRecord
  has_many :backups

  validates :name, presence: true

  after_create :create_empty_backup

  def create_empty_backup
    backups.create!
  end
end
