class AnswersController < ApplicationController
  before_action :question, only: %i[new]

  def new
    @answer = @question.answers.new
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end
end
