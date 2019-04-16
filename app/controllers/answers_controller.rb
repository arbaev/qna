class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[destroy]
  before_action :set_question, only: %i[create destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      flash.now[:notice] = 'answer successfully created'
    else
      flash.now[:alert] = 'please, enter text of answer'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'answer successfully deleted'
    else
      flash.now[:alert] = 'only author can delete answer'
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = @answer.nil? ? Question.find(params[:question_id]) : @answer.question
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
