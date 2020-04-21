class ServerCommand < ApplicationRecord
  belongs_to :server

  validates :text, presence: true
end
