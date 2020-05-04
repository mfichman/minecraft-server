class Wireguard::Peer < ApplicationRecord
  belongs_to :key
  belongs_to :network

  validates :ip_address, presence: true, ip_address: { prefix: 32 }
  validate :validate_ip_in_range

  def assign_ip_address
    if ip_address.blank?
      prev = IPAddr.new((network.peers.order(:id).last || network).ip_address)
      self.ip_address = "#{IPAddr.new(prev.to_i + 1, Socket::AF_INET)}/32"
    end
  end

  def validate_ip_in_range
    range = IPAddr.new(network.ip_address).to_range
    errors.add(:ip_address, :out_of_range) if range.exclude?(ip_address)
  end
end
