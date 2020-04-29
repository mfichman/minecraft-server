class Wireguard::Peer < ApplicationRecord
  belongs_to :key
  belongs_to :network

  validates :ip_address, presence: true, ip_address: true
  validate :validate_ip_in_range

  def assign_ip_address
    prev = (network.peers.order(:ip_address).last || network).ip_address
    self.ip_address = IPAddr.new(IPAddr.new(prev).to_i + 1, Socket::AF_INET).to_s
  end

  def validate_ip_in_range
    range = IPAddr.new(network.ip_address).to_range
    errors.add(:ip_address, :out_of_range) if range.exclude?(ip_address)
  end
end
