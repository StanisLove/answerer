module Concerns::Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy

    accepts_nested_attributes_for :comments, reject_if: proc { |a| a['body'].blank? }
  end

  def add_comment!(commentable_params, current_user)
    if commentable_params[:comments_attributes][:body].blank?
      errors.add(:comment, "body can't be blank")
    else
      commentable_params[:comments_attributes].merge!(user_id: current_user.id)
      commentable_params[:comments_attributes] = [commentable_params[:comments_attributes]]
      update(commentable_params)
    end
  end
end
