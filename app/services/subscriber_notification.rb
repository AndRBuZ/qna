class SubscriberNotification
  def notify_subscribers(question)
    User.joins(:subscriptions).where(subscriptions: { question_id: Question.last }).find_each do |user|
      SubscriberNotificationMailer.notify_subscribers(user, question).deliver_later
    end
  end
end
