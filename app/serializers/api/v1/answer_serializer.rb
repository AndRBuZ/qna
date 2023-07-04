class Api::V1::AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :best, :created_at, :updated_at, :files
  has_many :links
  has_many :comments

  def files
    files = []
    object.files.each do |file|
      files << url_for(file)
    end
    files
  end
end
