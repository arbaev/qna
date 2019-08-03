class NewAnswersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswer.new.send_notification(answer)
  end
end
