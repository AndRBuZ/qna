class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :awards, through: :answers
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def create_unconfirmed_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid, confirmation_token: Devise.friendly_token)
  end

  def auth_confirmed?(auth)
    auth && self.authorizations.find_by(provider: auth.provider, uid: auth.uid)&.confirmed?
  end

  def generate_password
    self.password = self.password_confirmation = Devise.friendly_token[0, 20]
    self
  end

  def author_of?(object)
    self.id == object.user_id
  end
end
