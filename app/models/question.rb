class Question < ActiveRecord::Base
  has_many  :answers, dependent: :destroy
  belongs_to  :user
  has_many  :attachments, as: :attachable, dependent: :destroy

  validates :title, :body, :user_id, presence: true
  validates :title, length: { maximum: 140 }

  accepts_nested_attributes_for :attachments,
                                allow_destroy: true,
                                reject_if: proc { |a| a['file'].blank? }
end
