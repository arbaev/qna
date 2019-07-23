# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities
    can :read, User
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer], author_id: user.id

    can :best, Answer, question: { author_id: user.id }
    can :manage, ActiveStorage::Attachment do |attachment|
      user.author_of? attachment.record
    end

    can :manage, Link, linkable: { author_id: user.id }

    can :manage, Votable, votable: { author_id: !user.id }

    can :manage, Reward, question: { author_id: user.id }
  end
end
