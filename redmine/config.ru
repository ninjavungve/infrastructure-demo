ENV['RAILS_ENV'] ||= ENV['RACK_ENV']
ENV['RAILS_RELATIVE_URL_ROOT'] = '/redmine'
require ::File.expand_path('../config/environment', __FILE__)
map ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
  use Rails::Rack::Static #if Rails.env.development?
  run ActionController::Dispatcher.new
end
