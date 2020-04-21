class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i(google_oauth2)

  def self.from_omniauth(auth)
    transaction do
      user = find_or_initialize_by(email: auth.info.email)
      user.update!(oauth_provider: auth.provider, oauth_uid: auth.uid)
      user
    end
  end

  def admin?
    id == 1
  end
end
