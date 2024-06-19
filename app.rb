require 'sinatra'

require_relative './rutas/utiles'
require_relative './rutas/rutas_usuarios'
require_relative './rutas/rutas_contenidos'
require_relative './rutas/rutas_calificaciones'
require_relative './rutas/rutas_visualizaciones'
require_relative './rutas/rutas_favoritos'

configure do
  set :default_content_type, :json
end

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
  pass unless ENV['APP_MODE'] == 'test'

  settings.logger.debug '[POST] /reset - Reinicia la base de datos'

  AbstractRepository.subclasses.each do |repositorio|
    repositorio.new.delete_all
  end

  estado = 200

  settings.logger.debug "Respuesta - [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
end

get '/salud' do
  settings.logger.debug '[GET] /salud_de_la_app - Consultando el estado de la APP tras deployar'

  version = Version.current
  cantidad_de_usuarios = DB[:usuarios].all.count

  estado = 200
  cuerpo = { 'Respuesta' => 'La API se deployo con exito', 'version' => version, 'cantidad_de_usuarios' => cantidad_de_usuarios }

  settings.logger.debug "Respuesta - [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end
