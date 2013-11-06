ENV['RAILS_ENV'] ||= ENV['RACK_ENV']
require ::File.expand_path('../config/environment', __FILE__)
use Rails::Rack::Static #if Rails.env.development?
run ActionController::Dispatcher.new
