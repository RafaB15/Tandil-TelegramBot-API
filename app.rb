require 'sinatra'
require_relative './lib/version'

get '/version' do
  { version: Version.current }.to_json
end
