require 'rails_helper'

RSpec.describe Services::NewAnswer do
  let(:users) { create_list :user, 5 }
  let(:question) { create :question, author: users.first }
  let(:answer) { create :answer, question: question, author: users.last }
  let!(:sub2) { create :subscription, user: users[2], question: question }
  let!(:sub3) { create :subscription, user: users.last, question: question }

  it 'send new answer to question subscribers' do
    Subscription.find_each do |sub|
      expect(NewAnswerMailer).to receive(:notification).with(sub.user, answer).and_call_original
    end

    subject.send_notification(answer)
  end
end
