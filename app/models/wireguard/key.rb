class Wireguard::Key < ApplicationRecord
  before_create :generate

  private

  def generate
    private_key = Rb25519.random_secret_str
    public_key = Rb25519.public_key_str(private_key)

    self.private_key = Base64.strict_encode64(private_key)
    self.public_key = Base64.strict_encode64(public_key)
  end
end
