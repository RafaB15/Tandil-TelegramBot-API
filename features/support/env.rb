# rubocop:disable all
ENV['APP_ENV'] = 'test'
require 'rack/test'
require 'rspec/expectations'
require_relative '../../app.rb'
require 'byebug'
require 'faraday'

include Rack::Test::Methods
def app
  Sinatra::Application
end

After do |_scenario|
  Faraday.post('/reset')
end
