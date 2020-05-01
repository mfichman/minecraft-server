class Minecraft::World < ApplicationRecord
  has_many :backups

  validates :name, presence: true

  after_create :create_empty_backup

  accepts_nested_attributes_for :backups

  def create_empty_backup
    backups.create! if backups.none?
  end
end
