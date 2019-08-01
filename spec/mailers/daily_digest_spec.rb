require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create :user }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:yesterday_questions) { create_list :question, 3, :created_yesterday }
    let!(:today_questions) { create_list :question, 3, :created_today }

    it "renders the headers" do
      expect(mail.subject).to eq "Daily questions digest from QNA"
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders only yesterday's question title" do
      expect(mail.body.encoded).to match(yesterday_questions.last.title)
      expect(mail.body.encoded).to_not match(today_questions.last.title)
    end
  end

end
