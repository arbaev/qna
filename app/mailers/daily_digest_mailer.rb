class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Date.today - 1)

    mail to: user.email,
         subject: 'Daily questions digest from QNA'
  end
end
