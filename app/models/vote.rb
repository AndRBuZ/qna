class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validate :validate_author_cant_vote

  enum vote: { upvote: 1, downvote: -1 }

  private

  def validate_author_cant_vote
    errors.add(:user, "Author can't vote") if user&.author_of?(votable)
  end
end
