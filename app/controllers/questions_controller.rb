class QuestionsController < ApplicationController
  before_action :question, only: %w[show edit]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  private

  def question
    @question = Question.find(params[:id])
  end
end
