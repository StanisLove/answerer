class UsersController < ApplicationController
  before_action :load_user, only: [:finish_signup]
  skip_before_action :authenticate_user!, only: [:finish_signup]

  def finish_signup
    if request.patch? && params[:user]
      if @user.update(user_params)
        redirect_to root_path
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
