# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy best]
  before_action :set_question, only: %i[create update destroy best]
  before_action :authority!, only: %i[update destroy]
  after_action :publish, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      NewAnswersJob.perform_now(@answer)
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
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[id name url _destroy])
  end

  def authority!
    unless current_user.author_of?(@answer)
      flash.now[:alert] = 'you must be author of answer'
      render 'questions/show'
    end
  end

  def publish
    return if @answer.errors.present?

    ActionCable.server.broadcast "question#{@question.id}:answers",
                                 answer: @answer,
                                 author: @answer.author,
                                 links: @answer.links,
                                 files: files_data
  end

  def files_data
    @answer.files.map do |file|
      { id: file.id,
        url: url_for(file),
        name: file.filename.to_s }
    end
  end
end
