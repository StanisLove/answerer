class Answer < ActiveRecord::Base
  include Concerns::Attachable
  include Concerns::Votable
  include Concerns::Commentable

  belongs_to  :question, touch: true
  belongs_to  :user

  validates :body, :question_id, :user_id, presence: true

  after_commit :sent_notification, on: :create

  default_scope { order(is_best: :desc).order(created_at: :asc) }

  def make_best!
    Answer.transaction do
      question.answers.update_all(is_best: false, updated_at: Time.now)
      toggle!(:is_best)
    end
  end

  private

  def sent_notification
    NewAnswerNotificationJob.perform_now(self)
  end
end
