require 'sinatra'

require_relative './rutas/utiles'
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
