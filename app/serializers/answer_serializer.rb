class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :is_best, :created_at, :updated_at
end
