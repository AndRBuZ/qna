# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can [:update, :destroy], [Question, Answer, Comment], user_id: user.id
    can [:upvote, :downvote], [Question, Answer]
    cannot [:upvote, :downvote], [Question, Answer], user_id: user.id
    can :best, Answer, question: { user_id: user.id }
    can :me, :profile
    can :index, :profile
    can :destroy, [Subscription]
  end
end
