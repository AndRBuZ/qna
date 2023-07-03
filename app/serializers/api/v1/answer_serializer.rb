class Api::V1::AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at, :files
  has_many :links
  has_many :comments

  def files
    files = []
    object.files.each do |file|
      files << file.url
    end
    files
  end
end
