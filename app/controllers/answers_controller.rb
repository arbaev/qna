class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy]
  before_action :set_question, only: %i[create update destroy]
  before_action :authority!, only: %i[update destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      flash.now[:notice] = 'answer successfully created'
    else
      flash.now[:alert] = 'please, enter text of answer'
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = 'answer successfully edited'
    else
      flash.now[:alert] = 'editing answer failed'
    end
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = 'answer successfully deleted'
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

  def authority!
    unless current_user.author_of?(@answer)
      flash.now[:alert] = 'you must be author of answer'
      head 403
    end
  end
end
