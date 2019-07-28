class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    questions = Question.all
    render json: questions
  end

  def show
    render json: question
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

end
