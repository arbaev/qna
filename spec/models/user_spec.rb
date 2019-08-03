require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:user2) { create :user }
  let(:question) { create :question, author: user }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of(:email) }

  describe 'user is an author of' do
    it 'his question and answer' do
      expect(user).to be_author_of(question)
    end

    it 'not his question and answer' do
      expect(user2).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#subscribed_to?' do
    let!(:subscription) { create :subscription, user: user, question: question }

    it 'user subscribed' do
      expect(user).to be_subscribed_to question
    end

    it 'user2 does not subscribed' do
      expect(user2).to_not be_subscribed_to question
    end
  end
end
