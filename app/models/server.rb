class Server < ApplicationRecord
  has_many :server_logs
  has_many :server_commands

  validates :host, presence: true
end
