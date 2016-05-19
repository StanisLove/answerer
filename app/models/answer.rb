class Answer < ActiveRecord::Base
  belongs_to  :question
  belongs_to  :user
  has_many    :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  scope :order_by_best, -> { order(is_best: :desc) }

  def make_best!
    Answer.transaction do
      self.question.answers.update_all(is_best: false)
      self.toggle!(:is_best)
    end
  end
end
