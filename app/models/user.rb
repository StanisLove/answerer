class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many  :questions,      dependent: :destroy
  has_many  :answers,        dependent: :destroy
  has_many  :votes,          dependent: :destroy
  has_many  :comments,       dependent: :destroy
  has_many  :authorizations, dependent: :destroy

  def self.find_for_oauth(auth, current_user_or_email = nil)
    authorization = Authorization.where(provider: auth.provider,
                                        uid:      auth.uid.to_s).first
    return authorization.user if authorization

    if current_user_or_email.is_a? User
      current_user_or_email.authorizations.create(provider:     auth.provider,
                                                  uid:          auth.uid,
                                                  confirmed_at: Time.now)
      return current_user_or_email
    end

    auth_email = auth.info.try(:email)
    email      = current_user_or_email || auth_email

    if email
      user     = User.where(email: email).first
      password = Devise.friendly_token[0, 20]

      transaction do
        user = User.create!(email:                 email,
                            password:              password,
                            password_confirmation: password,
                            confirmed_at:          Time.now) unless user

        authorization = user.authorizations.create!(provider:     auth.provider,
                                                    uid:          auth.uid,
                                                    confirmed_at: auth_email ? Time.now : nil)
      end
    end
    user
  end
end
