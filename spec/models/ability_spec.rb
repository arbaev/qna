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

  describe 'for user' do
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:question) { create :question, author: user }
    let(:question2) { create :question, author: user2 }
    let(:answer) { create :answer, question: question, author: user }
    let(:answer2) { create :answer, question: question, author: user2 }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question, user: user) }
    it { should_not be_able_to :update, question, user: user2) }

    it { should be_able_to :update, answer, user: user) }
    it { should_not be_able_to :update, answer, user: user2) }
  end
end
