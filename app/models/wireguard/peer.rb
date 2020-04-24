class Wireguard::Peer < ApplicationRecord
  belongs_to :key
  belongs_to :network

  validates :ip_address, presence: true, ip_address: true
end
