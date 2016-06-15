class Answer < ActiveRecord::Base
  include Concerns::Attachable
  include Concerns::Votable
  include Concerns::Commentable

  belongs_to  :question
  belongs_to  :user

  validates :body, :question_id, :user_id, presence: true

  scope :order_by_best, -> { order(is_best: :desc).order(created_at: :asc) }

  def make_best!
    Answer.transaction do
      self.question.answers.update_all(is_best: false) 
      self.toggle!(:is_best)
    end
  end
end
