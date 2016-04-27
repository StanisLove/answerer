class Question < ActiveRecord::Base
  has_many  :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 140 }
end
