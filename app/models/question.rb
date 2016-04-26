class Question < ActiveRecord::Base
  has_many  :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates_length_of :title, maximum: 140
  validates_uniqueness_of :title
end
