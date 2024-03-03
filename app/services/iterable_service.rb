require 'webmock'
include WebMock::API

WebMock.enable!

class IterableService < ApplicationService
  attr_reader :user, :params


  def initialize(user, params)
    @user = user
    @params = params
    @api_key = Rails.application.credentials.iterable_api_key
  end

  # Narrow scope: We should move all API calls to worker. Here are the steps:
  # 1. move to worker and notify user that the request was queued.
  # 2. Inside worker if the request returns successfull status, we publish a success event, else we publish a failure event.
  # 3. On frontend using web socket service like pusher we notify user appropriately.
  def call
    event_response = create_event(user, params[:event_type])
    if params[:event_type] == 'EventB'
      email_response = send_email_notification(user.email, params[:event_type])
      return email_response
    end
    event_response
  end

  # create_event & send_email_notification uses Net::HTTP, in real app we should prefer library like RestClient or HTTParty.
  def create_event(user, event_name)
    stub_event_request

    uri = URI.parse("https://api.iterable.com/api/embedded-messaging/events/click")
    req = Net::HTTP::Post.new(uri.path)
    req['Content-Length'] = 3

    Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req, "abc")
    end
  end

  def send_email_notification(email, event_type)
    stub_email_notification_request

    uri = URI.parse("https://api.iterable.com/api/email/target")
    req = Net::HTTP::Post.new(uri.path)
    req['Content-Length'] = 3

    Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req, "abc")
    end
  end

  private
  def stub_event_request
    stub_request(
      :post,
      "http://api.iterable.com:443/api/embedded-messaging/events/click"
    ).with(
      body: "abc",
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Length'=>'3',
        'User-Agent'=>'Ruby'
    }).to_return(status: 200, body: "", headers: {})
  end

  def stub_email_notification_request
    stub_request(
      :post,
      "http://api.iterable.com:443/api/email/target"
    ).with(
      body: "abc",
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Length'=>'3',
        'User-Agent'=>'Ruby'
    }).to_return(status: 200, body: "", headers: {})
  end
end
