class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy best]
  before_action :set_question, only: %i[create update destroy best]
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

  def best
    if current_user.author_of?(@question)
      @answer.set_best!
    else
      flash.now[:alert] = 'you must be author of question'
    end
  end

  private

  def set_question
    @question = @answer.nil? ? Question.find(params[:question_id]) : @answer.question
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def authority!
    unless current_user.author_of?(@answer)
      flash.now[:alert] = 'you must be author of answer'
      render 'questions/show'
    end
  end
end
