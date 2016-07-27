# frozen_string_literal: true
module Concerns::Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up!(current_user)
    create_vote(current_user, 1) unless bad_conditions(current_user)
  end

  def vote_down!(current_user)
    create_vote(current_user, -1) unless bad_conditions(current_user)
  end

  def voting_result
    votes.sum(:voice)
  end

  def vote_reset!(current_user)
    votes.where(user: current_user).delete_all
  end

  private

  def bad_conditions(current_user)
    if current_user.id == user_id
      errors.add(:user,
                 "cannot vote for own #{model_name.singular}")
    elsif already_votes?(current_user)
      errors.add(:user,
                 "cannot vote two times for one #{model_name.singular}")
    else
      false
    end
  end

  def already_votes?(current_user)
    !votes.find_by(user: current_user).nil?
  end

  def create_vote(current_user, voice)
    votes.create(user: current_user, voice: voice)
  end
end
