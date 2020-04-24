class Minecraft::Command < ApplicationRecord
  belongs_to :server

  validates :text, presence: true
end
