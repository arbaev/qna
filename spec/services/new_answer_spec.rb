require 'rails_helper'

RSpec.describe Services::NewAnswer do
  let(:users) { create_list :user, 5 }
  let(:question) { create :question, author: users.first }
  let(:answer) { create :answer, question: question, author: users.last }
  let(:sub1) { create :subscription, user: users.first, question: question }
  let(:sub2) { create :subscription, user: users.last, question: question }
  let(:subscribers) { [sub1, sub2] }

  it 'send new answer to question subscribers' do
    subscribers.each do |subscription|
      expect(NewAnswerMailer).to receive(:notification).with(subscription.user, answer).and_call_original
    end

    subject.send_notification(answer)
  end
end
