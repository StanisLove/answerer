class Answer < ActiveRecord::Base
  include Concerns::Attachable
  include Concerns::Votable
  include Concerns::Commentable

  belongs_to  :question
  belongs_to  :user

  validates :body, :question_id, :user_id, presence: true

  after_commit :sent_notification, on: :create

  scope :order_by_best, -> { order(is_best: :desc).order(created_at: :asc) }

  def make_best!
    Answer.transaction do
      self.question.answers.update_all(is_best: false)
      self.toggle!(:is_best)
    end
  end

  private
    def sent_notification
      NewAnswerNotificationJob.perform_now(self)
    end
end
