class Question < ActiveRecord::Base
  has_many  :answers, dependent: :destroy
  belongs_to  :user
  has_many  :attachments, dependent: :destroy

  validates :title, :body, :user_id, presence: true
  validates :title, length: { maximum: 140 }

  accepts_nested_attributes_for :attachments
end
