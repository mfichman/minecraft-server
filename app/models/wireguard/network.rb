class Wireguard::Network < ApplicationRecord
  belongs_to :key

  has_many :peers

  validates :ip_address, presence: true, ip_address: true
end
