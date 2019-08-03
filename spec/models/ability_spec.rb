require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create :question, :with_attachment, author: user }
    let(:answer) { create :answer, :with_attachment, question: question, author: user }
    let(:answer_for_question_user2) { create :answer, question: question_user2, author: user }
    let(:subscription) { create :subscription, user: user, question: question }

    let(:user2) { create :user }
    let(:question_user2) { create :question, :with_attachment, author: user2 }
    let(:answer_user2) { create :answer, :with_attachment, question: question, author: user2 }
    let(:subscription_user2) { create :subscription, user: user2, question: question }

    it { should_not be_able_to :manage, :all }

    context 'general CRUD actions' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Subscription }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, question_user2 }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, answer_user2 }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, question_user2 }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, answer_user2 }
      it { should be_able_to :destroy, subscription }
      it { should_not be_able_to :destroy, subscription_user2 }
    end

    context 'reading users profile' do
      it { should be_able_to :read, user }
      it { should_not be_able_to :read, user2 }
      it { should be_able_to :me, user }
    end

    context 'selecting best answer' do
      it { should be_able_to :best, answer_user2 }
      it { should_not be_able_to :best, answer_for_question_user2 }
    end

    context 'voting' do
      it { should be_able_to :vote_up, question_user2 }
      it { should be_able_to :vote_down, question_user2 }
      it { should_not be_able_to :vote_up, question }
      it { should_not be_able_to :vote_down, question }
      it { should be_able_to :vote_up, answer_user2 }
      it { should be_able_to :vote_down, answer_user2 }
      it { should_not be_able_to :vote_up, answer }
      it { should_not be_able_to :vote_down, answer }
    end

    context 'attaching files' do
      it { should be_able_to :destroy, question.files.last }
      it { should_not be_able_to :destroy, question_user2.files.last }
      it { should be_able_to :destroy, answer.files.last }
      it { should_not be_able_to :destroy, answer_user2.files.last }
    end
  end
end
