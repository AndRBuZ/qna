class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create, :destroy]
  before_action :set_subscription, only: [:destroy]

  authorize_resource

  def create
    @subscription = current_user.subscriptions.new(subscription_params)
    @subscription.save

    render partial: 'questions/subscription'
  end

  def destroy
    @subscription.destroy
    @subscription = nil

    render partial: 'questions/subscription'
  end

  private

  def subscription_params
    params.permit(:question_id)
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
