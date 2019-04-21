class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  def best_answer_first
    question.best_answer_id == id ? 0 : updated_at.to_i
  end
end
