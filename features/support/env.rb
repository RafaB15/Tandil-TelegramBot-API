# rubocop:disable all
ENV['APP_ENV'] = 'test'
require 'rack/test'
require 'rspec/expectations'
require_relative '../../app.rb'
require 'byebug'
require 'faraday'

DB = Configuration.db
Sequel.extension :migration
logger = Configuration.logger
db = Configuration.db
db.loggers << logger
Sequel::Migrator.run(db, 'db/migrations')


include Rack::Test::Methods
def app
  Sinatra::Application
end


After do |_scenario|
  Faraday.post('/reset')
end
