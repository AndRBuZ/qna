require 'rails_helper'

RSpec.describe SubscriberNotification do
  let(:users) { create_list(:user, 3) }
  let(:questions) { create_list(:question, 3) }

  it 'sends notification to all users with subscription' do
    Subscription.find_each do |subscription|
      expect(SubscriberNotificationMailer).to receive(:notify_subscribers).with(subscription.user, questions).and_call_original
    end

    SubscriberNotification.new.notify_subscribers(questions)
  end

  it 'does not send notification to users without subscription' do
    users.each do |user|
      expect(SubscriberNotificationMailer).to_not receive(:notify_subscribers).with(user. questions)
    end

    SubscriberNotification.new.notify_subscribers(questions)
  end
end
