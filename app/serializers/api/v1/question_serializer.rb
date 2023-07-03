class Api::V1::QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :files
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
