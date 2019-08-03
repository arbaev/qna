class NewAnswerMailer < ApplicationMailer
  def notification(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email,
         subject: "QNA: There is a new answer for your question"
  end
end
