class Question < ActiveRecord::Base
  validates :title, :body, presence: true
  validates_length_of :title, maximum: 140
end
