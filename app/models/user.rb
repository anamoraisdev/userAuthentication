class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  validates :name, presence: false
  validates :birthdate, presence: false
  validates :address, presence: false

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :confirmable,
  :jwt_authenticatable, jwt_revocation_strategy: self

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
  
end
