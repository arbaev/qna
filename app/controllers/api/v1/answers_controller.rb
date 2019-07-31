# frozen_string_literal: true
class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    render json: question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end

  def create
    answer = question.answers.new(answer_params)
    answer.author = current_resource_owner

    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if answer.destroy!
      render json: {}, status: :ok
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
