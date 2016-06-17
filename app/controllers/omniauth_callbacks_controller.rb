class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env['omniauth.auth'], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication if @user.email_verified?
          redirect_to finish_signup_path(@user) unless @user.email_verified?
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:facebook, :twitter].each do |provider|
    callback_for provider
  end
end
