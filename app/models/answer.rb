class Answer < ActiveRecord::Base
  belongs_to  :question
  belongs_to  :user

  validates :body, :question_id, :user_id, presence: true

  scope :order_by_best, -> { order(is_best: :desc) }

  def make_best!
    self.toggle!(:is_best)
  end
end
