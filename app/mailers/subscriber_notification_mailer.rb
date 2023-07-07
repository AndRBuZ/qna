class SubscriberNotificationMailer < ApplicationMailer
  def notify_subscribers(user, question)
    @question = question

    mail to: user.email
  end
end
