class Wireguard::Key < ApplicationRecord
  before_create :generate_private_key
  before_create :generate_public_key

  private

  def private_key_bytes
    Base64.strict_decode64(private_key)
  end

  def public_key_bytes
    Base64.strict_decode64(public_key)
  end

  def generate_private_key
    self.private_key ||= Base64.strict_encode64(Rb25519.random_secret_str)
  end

  def generate_public_key
    self.public_key = Base64.strict_encode64(Rb25519.public_key_str(private_key_bytes))
  end
end
