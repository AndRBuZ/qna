require 'rails_helper'

RSpec.describe SubscriberNotificationJob, type: :job do
  let(:service) { double('SubscriberNotification') }
  let(:answer) { create(:answer) }

  before do
    allow(SubscriberNotification).to receive(:new).and_return(service)
  end

  it 'calls SubscriberNotification#notify_subscribers' do
    expect(service).to receive(:notify_subscribers).with(answer.question)
    SubscriberNotificationJob.perform_now(answer.question)
  end
end
