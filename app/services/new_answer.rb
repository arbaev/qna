class Services::NewAnswer
  def send_notification(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerMailer.notification(subscription.user, answer).deliver_later
    end
  end
end
