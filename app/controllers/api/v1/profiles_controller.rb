class Api::V1::ProfilesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :doorkeeper_authorize!

  respond_to :json

  def index
    respond_with other_users
  end

  def me
    respond_with current_resource_owner
  end

  protected

    def current_resource_owner
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def other_users
      User.all.where.not(id: current_resource_owner.id)
    end
end
