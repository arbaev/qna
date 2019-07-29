class Api::V1::AnswersController < Api::V1::BaseController
  def index
    render json: question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end
end
