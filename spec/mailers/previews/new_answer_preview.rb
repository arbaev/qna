# Preview all emails at http://localhost:3000/rails/mailers/new_answer
class NewAnswerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer/notification
  def notification
    NewAnswerMailer.notification(Question.first)
  end

end
