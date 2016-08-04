class AuthorizationsController < ApplicationController
  before_action      :load_auth_and_email, only: :create
  before_action      :load_authorization,  only: :confirm
  skip_before_action :authenticate_user!

  def new
    @authorization = Authorization.new
  end

  def create
    User.find_for_oauth(@auth, @email)
    redirect_to root_path
    flash[:notice] = "Confirmation email was sent to #{@email}"
  rescue ActiveRecord::RecordInvalid
    redirect_to new_user_registration_path
    flash[:notice] = 'Authorization error.'
  end

  def confirm
    if @authorization.confirmation_token == params[:token] && @authorization.update(confirmed_at: Time.now)
      sign_in_and_redirect @authorization.user
      flash[:notice] = 'Email successfully confirmed.'
    else
      redirect_to root_path
      flash[:alert] = 'Email confirmation error.'
    end
  end

  private

  def load_auth_and_email
    @email = params[:authorization][:email]
    @auth  = OmniAuth::AuthHash.new(session['devise.provider_data'])
  end

  def load_authorization
    @authorization = Authorization.find(params[:id])
  end
end
