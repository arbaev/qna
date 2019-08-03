class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_subscription, only: :destroy

  authorize_resource

  def create
    @subscription = @question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end
end
