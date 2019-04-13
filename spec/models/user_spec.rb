require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of(:email) }

  describe 'user is an author of' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let(:answer) { create(:answer, question: question, author_id: user.id) }

    it 'his question and answer' do
      expect(user.author_of?(question)).to be true
      expect(user.author_of?(answer)).to be true
    end

    it 'not his question and answer' do
      expect(user2.author_of?(question)).to be false
      expect(user2.author_of?(answer)).to be false
    end
  end

end
