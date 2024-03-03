Iterable.configure do |config|
  config.token =  Rails.application.credentials.iterable_api_key
end
