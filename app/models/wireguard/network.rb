class Wireguard::Network < ApplicationRecord
  belongs_to :key

  validates :ip_address, presence: true, ip_address: true
end
