class SubscriberNotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    SubscriberNotification.new.notify_subscribers(question)
  end
end
