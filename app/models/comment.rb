class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates  :body, :user_id, presence: true
  validates  :body, length: { maximum: 1000 }

  scope :asc, -> { order(created_at: :asc) }
end
