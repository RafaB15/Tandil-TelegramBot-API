require 'sinatra'
require 'sequel'
require 'sinatra/custom_logger'
require_relative './config/configuration'

Dir[File.join(__dir__, '/controladores', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '/dominio', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '/persistencia', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '/lib', '*.rb')].each { |file| require file }

customer_logger = Configuration.logger
set :logger, customer_logger
DB = Configuration.db
DB.loggers << customer_logger

require_relative './rutas/rutas_usuarios'
require_relative './rutas/rutas_contenidos'
require_relative './rutas/rutas_calificaciones'
require_relative './rutas/rutas_visualizaciones'
require_relative './rutas/rutas_favoritos'

get '/version' do
  settings.logger.debug '[GET] /version - Consultando la version de la API Rest'

  version = Version.current

  estado = 200
  cuerpo = { version: }

  settings.logger.debug "Respuesta - [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end

post '/reset' do
  settings.logger.debug '[POST] /reset - Reinicia la base de datos'

  AbstractRepository.subclasses.each do |repositorio|
    repositorio.new.delete_all
  end

  estado = 200

  settings.logger.debug "Respuesta - [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
end
