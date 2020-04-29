class Wireguard::Network < ApplicationRecord
  PORT = 51820

  belongs_to :key

  has_many :peers

  validates :ip_address, presence: true, ip_address: true
end
