module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :vote_reset]
  end

  def vote_up
    @votable.vote_up!(current_user)
    if @votable.save
      render json: @votable.voting_result
    else
      render json: @votable.errors_full_messages, status: :unprocessable_entity
    end
  end

  def vote_down
    @votable.vote_down!(current_user)
    if @votable.save
      render json: @votable.voting_result
    else
      render json: @votable.errors_full_messages, status: :unprocessable_entity
    end
  end

  def vote_reset
    @votable.vote_reset!(current_user)
    render json: @votable.voting_result
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
