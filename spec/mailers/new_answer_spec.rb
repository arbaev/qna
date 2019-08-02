require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "notification" do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, question: question }
    let(:mail) { NewAnswerMailer.notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("QNA: There is a new answer for your question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
