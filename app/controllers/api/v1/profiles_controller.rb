class Api::V1::ProfilesController < Api::V1::BaseController
  def index
    respond_with other_users
  end

  def me
    respond_with current_resource_owner
  end

  protected

  def other_users
    User.all.where.not(id: current_resource_owner.id)
  end
end
