require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  context 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  context 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :upvote, create(:question, user: other) }
    it { should_not be_able_to :upvote, create(:question, user: user) }

    it { should be_able_to :downvote, create(:question, user: other) }
    it { should_not be_able_to :downvote, create(:question, user: user) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other) }

    it { should be_able_to :upvote, create(:answer, user: other) }
    it { should_not be_able_to :upvote, create(:answer, user: user) }

    it { should be_able_to :downvote, create(:answer, user: other) }
    it { should_not be_able_to :downvote, create(:answer, user: user) }

    it { should be_able_to :best, create(:answer, question: create(:question, user: user )) }
    it { should_not be_able_to :best, create(:answer, question: create(:question, user: other )) }
  end
end
