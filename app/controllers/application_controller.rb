require "application_responder"

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  check_authorization unless: :do_not_check_authorization?

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  

  protected
    def not_found
      redirect_to root_url, flash: { error: "Запись не найдена" }
    end

    def do_not_check_authorization?
      respond_to?(:devise_controller?)
    end

end
