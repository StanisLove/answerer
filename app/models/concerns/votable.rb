module Concerns::Votable
  extend ActiveSupport::Concern

  included do
    has_many  :votes, as: :votable, dependent: :destroy

    accepts_nested_attributes_for :votes, allow_destroy: true
  end

  def vote_up!(current_user)
    create_vote(current_user, true) unless bad_conditions(current_user)
  end

  def vote_down!(current_user)
    create_vote(current_user, false) unless bad_conditions(current_user)
  end

  def voting_result
    result(true) - result(false)
  end

  def vote_reset!(current_user)
    Vote.where(user_id: current_user.id, votable_type: model_name.name,
               votable_id: self.id).delete_all
  end

  private

    def bad_conditions(current_user)
      if current_user.id == self.user_id
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
      !Vote.find_by(user_id: current_user.id,
                    votable_type: model_name.name,
                    votable_id: self.id).nil?
    end

    def create_vote(current_user, voice)
      Vote.create(user_id: current_user.id, voice: voice,
                  votable_type: model_name.name, votable_id: self.id)
    end

    def result(voice)
      Vote.where(votable_id: self.id, votable_type: model_name.name,
                 voice: voice).count 
    end
end
