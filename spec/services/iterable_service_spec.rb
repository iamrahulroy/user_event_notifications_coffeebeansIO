require 'rails_helper'
require 'webmock/rspec'

RSpec.describe IterableService, type: :service do
  let(:user) { double("User", email: "test@example.com") }
  let(:params) { { event_type: "EventA" } }

  subject { described_class.new(user, params) } # Provide user and params to initialize method

  describe "#call" do
    context "when event type is EventA" do
      it "calls create_event method" do
        expect(subject).to receive(:create_event).with(user, "EventA")
        subject.call
      end
    end

    context "when event type is EventB" do
      let(:params) { { event_type: "EventB" } }

      it "calls send_email_notification method" do
        expect(subject).to receive(:send_email_notification).with("test@example.com", "EventB")
        subject.call
      end
    end
  end

  describe "#create_event" do
    it "sends a request to Iterable API for event creation" do
      expect(Net::HTTP).to receive(:start).and_call_original
      subject.create_event(user, "EventA")
    end
  end

  describe "#send_email_notification" do
    it "sends a request to Iterable API for sending email notification" do
      expect(Net::HTTP).to receive(:start).and_call_original
      subject.send_email_notification("test@example.com", "EventB")
    end
  end
end
