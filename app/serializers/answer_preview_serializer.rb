class AnswerPreviewSerializer < ActiveModel::Serializer
  attributes :id, :body, :is_best, :created_at, :updated_at
  has_many :comments
  has_many :attachments
end
