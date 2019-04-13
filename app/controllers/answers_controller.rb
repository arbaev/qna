class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[destroy]
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'answer successfully created'
    else
      @question.answers.destroy(@answer) # delete invalid nil answer
      flash.now[:alert] = "please, enter answer's text"
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'answer successfully deleted'
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
