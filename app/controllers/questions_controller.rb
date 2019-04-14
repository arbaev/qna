class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :set_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'question successfully created'
    else
      flash.now[:alert] = 'please, enter valid data'
      render :new
    end
  end

  def show; end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'question successfully deleted'
    else
      flash.now[:alert] = 'only author can delete question'
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
