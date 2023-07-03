class Api::V1::AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best
  belongs_to :user
end
