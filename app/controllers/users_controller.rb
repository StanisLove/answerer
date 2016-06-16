class UsersController < ApplicationController
  before_action :load_user, only: [:finish_signup]

  def finish_signup
    if request.patch? && params[:user]
      if @user.update(user_params)
        #@user.skip_reconfirmation!
        sign_in(@user, bypass: true)
        redirect_to root_path, notice: 'Your email successfully confirmed'
      else
        :js
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:email)
    end
    
    def load_user
      @user = User.find(params[:id])
    end
end
