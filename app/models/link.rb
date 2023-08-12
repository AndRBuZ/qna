class Link < ApplicationRecord
  URL_FORMAT = %r{\A(https?://)([\da-z.-]+)\.([a-z.]{2,6})([/\w.-]*)*/?\Z}i.freeze

  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, format: { with: URL_FORMAT }

  def gist?
    url.include?('gist')
  end

  def gist_id
    url.split('/').last
  end
end
