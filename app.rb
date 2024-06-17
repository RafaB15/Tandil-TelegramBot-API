require_relative './rutas/utiles'
require_relative './rutas/rutas_usuarios'
require_relative './rutas/rutas_contenidos'
require_relative './rutas/rutas_calificaciones'
require_relative './rutas/rutas_visualizaciones'
require_relative './rutas/rutas_favoritos'

get '/version' do
  settings.logger.info '[GET] /version - Consultando la version de la API Rest'

  version = Version.current
  cuerpo = { version: }

  settings.logger.info "Respuesta - [Estado] : 200 - [Cuerpo] : #{cuerpo}"

  status 200
  cuerpo.to_json
end

post '/reset' do
  settings.logger.info '[POST] /reset - Reinicia la base de datos'

  AbstractRepository.subclasses.each do |repositorio|
    repositorio.new.delete_all
  end

  settings.logger.info 'Respuesta - [Estado] : 200 - [Cuerpo] : vacio'

  status 200
end
