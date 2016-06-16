class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many  :questions, dependent: :destroy
  has_many  :answers,   dependent: :destroy
  has_many  :votes,     dependent: :destroy
  has_many  :comments,  dependent: :destroy
  has_many  :authorizations, dependent: :destroy

  def self.find_for_oauth(auth, current_user = nil)
    authorization = Authorization.find_or_create_by(provider: auth.provider, uid: auth.uid.to_s)

    user = current_user ? current_user : authorization.user

    if user.nil?
     # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email #if email_is_verified
      user = User.where(email: email).first #if email

      if user.nil?
        password = Devise.friendly_token[0, 20]
        user = User.new(
          email: email ? email : "#{auth.uid}-#{auth.provider}@change.me",
          password: password,
          password_confirmation: password)
        user.skip_confirmation!
        user.save!
      end
    end

    if authorization.user != user
      authorization.user = user
      authorization.save!
    end
    user
  end

  def email_verified?
    email && email !~ /.+@change.me/
  end
#  def self.find_for_oauth(auth, current_user = nil)
#    authorization = Authorization.where(provider: auth.provider, 
#                                        uid: auth.uid.to_s).first
#    return authorization.user if authorization
#
#    email = auth.info[:email]
#    user = User.where(email: email).first
#    if user
#      user.authorizations.create(provider: auth.provider, uid: auth.uid)
#    else
#      password = Devise.friendly_token[0, 20]
#      user = User.create!(email: email, password: password,
#                          password_confirmation: password)
#      user.authorizations.create(provider: auth.provider, uid: auth.uid)
#    end
#    user.skip_confirmation_notification!
#    user
#  end
#
#  def self.find_from_twitter(auth)
#    authorization = Authorization.where(provider: auth.provider, 
#                                        uid: auth.uid.to_s).first
#    return authorization.user if authorization
#  end
end
