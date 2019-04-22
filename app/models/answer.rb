class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  def set_best
    status = !self.best
    question.answers.update_all(best: false)
    update!(best: status)
  end

  def best_answer_first
    best ? 0 : created_at.to_i
  end
end
