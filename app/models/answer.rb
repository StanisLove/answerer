class Answer < ActiveRecord::Base
  belongs_to  :question
  belongs_to  :user

  validates :body, :question_id, :user_id, presence: true

  def make_best!
    self.toggle!(:is_best)
  end
end
