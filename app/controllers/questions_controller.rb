class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create update destroy delete_file]
  before_action :set_question, only: %i[show update destroy best_answer]
  before_action :authority!, only: %i[update destroy best_answer]

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

  def update
    if @question.update(question_params)
      flash.now[:notice] = 'question successfully edited'
    else
      flash.now[:alert] = 'question editing failed'
    end
  end

  def show; end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'question successfully deleted'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def authority!
    unless current_user.author_of?(@question)
      flash.now[:alert] = 'you must be author of question'
      render :show
    end
  end
end
