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
    can :read, [Question, Answer, Comment]
    can :search, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :read, user
    can :me, user

    can :create, :all
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer], author_id: user.id
    can :destroy, Subscription, user_id: user.id

    can :best, Answer, question: { author_id: user.id }

    can :manage, ActiveStorage::Attachment do |attachment|
      user.author_of? attachment.record
    end

    can [:vote_up, :vote_down], [Question, Answer] do |item|
      !user.author_of? item
    end
  end
end
