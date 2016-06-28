class Question < ActiveRecord::Base
  include Concerns::Attachable
  include Concerns::Votable
  include Concerns::Commentable

  has_many   :answers, dependent: :destroy
  belongs_to :user

  validates  :title, :body, :user_id, presence: true
  validates  :title, length: { maximum: 140 }
end
