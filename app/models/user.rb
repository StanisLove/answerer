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
      email = auth.info.email
      user = User.where(email: email).first if email

      if user.nil?
        password = Devise.friendly_token[0, 20]
        user = User.new(
          email: email ? email : "#{auth.uid}-#{auth.provider}@change.me",
          password: password,
          password_confirmation: password)
        user.skip_confirmation_notification!
        user.skip_confirmation! if user.email_verified?
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
end
