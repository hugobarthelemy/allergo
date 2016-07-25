class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :levels, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :scanned_products, dependent: :destroy
  has_many :tracked_products, dependent: :destroy

  has_many :allergies, through: :levels
  has_many :products, through: :tracked_products

  def self.find_for_facebook_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.picture = auth.info.image
      user.token = auth.credentials.token
      user.token_expiry = Time.at(auth.credentials.expires_at)
    end
  end

  def profile_pict
    # self.avatar = nil if self.picture ==""
    # default_pict = "avatardefault.jpg"
    # self.avatar || self.picture || default_pict
    if self.picture
      self.picture
    else
      "avatardefault.jpg"
    end
  end
end
