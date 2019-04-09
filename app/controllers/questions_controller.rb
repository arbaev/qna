class QuestionsController < ApplicationController
  before_action :question, only: %w[show]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      redirect_to @question, notice: 'question successfully created'
    else
      flash.now[:alert] = 'please, enter valid data'
      render :new
    end
  end

  def show
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def question
    @question = Question.find(params[:id])
  end
end
