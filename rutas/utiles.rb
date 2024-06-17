require 'sinatra'
require 'sequel'
require 'sinatra/custom_logger'
require_relative '../config/configuration'

Dir[File.join(__dir__, '../controladores', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../dominio', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../persistencia', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../lib', '*.rb')].each { |file| require file }

customer_logger = Configuration.logger
set :logger, customer_logger
DB = Configuration.db
DB.loggers << customer_logger

def enviar_respuesta(estado, respuesta)
  status(estado)
  respuesta.to_json
end
