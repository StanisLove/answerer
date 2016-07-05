class Question < ActiveRecord::Base
  include Concerns::Attachable
  include Concerns::Votable
  include Concerns::Commentable

  belongs_to :user
  has_many   :answers,       dependent: :destroy
  has_many   :subscriptions, dependent: :destroy
  has_many   :subscribers,   through:   :subscriptions

  validates  :title, :body, :user_id, presence: true
  validates  :title, length: { maximum: 140 }

  after_create :subscribe_author

  scope :during_last, lambda { |time| where("created_at > ?", (Time.now - time)) }

  private
    def subscribe_author
      subscriptions.create(user_id: self.user_id)
    end
end
