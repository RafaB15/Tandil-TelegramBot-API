require 'sinatra'
require 'sequel'
require 'sinatra/custom_logger'
require_relative './config/configuration'
Dir[File.join(__dir__, 'controladores', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'dominio', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'persistencia', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib/om_db_conector_api', '*.rb')].each { |file| require file }

customer_logger = Configuration.logger
set :logger, customer_logger
DB = Configuration.db
DB.loggers << customer_logger

def enviar_respuesta(controlador)
  status(controlador.estado)
  controlador.respuesta
end

def enviar_respuesta_nuevo(estado, respuesta)
  status(estado)
  respuesta.to_json
end

get '/version' do
  settings.logger.info '[GET] /version - Consultando la version de la API Rest'

  version = Version.current
  cuerpo = { version: }.to_json

  settings.logger.info "Respuesta - [Estado] : 200 - [Cuerpo] : #{cuerpo}"

  status 200
  cuerpo
end

post '/reset' do
  settings.logger.info '[POST] /reset - Reinicia la base de datos'

  AbstractRepository.subclasses.each do |repositorio|
    repositorio.new.delete_all
  end

  settings.logger.info 'Respuesta - [Estado] : 200 - [Cuerpo] : vacio'

  status 200
end

get '/usuarios' do
  settings.logger.info '[GET] /usuarios - Consultando los usuarios registrados'

  usuarios = RepositorioUsuarios.new.all
  cuerpo = usuarios.map do |u|
    {
      email: u.email,
      id_telegram: u.id_telegram,
      id: u.id
    }
  end.to_json

  settings.logger.info "Respuesta - [Estado] : 200 - [Cuerpo] : #{cuerpo}"

  status 200
  cuerpo
end

post '/usuarios' do
  @body ||= request.body.read
  parametros_usuario = JSON.parse(@body)
  email = parametros_usuario['email']
  id_telegram = parametros_usuario['id_telegram']

  settings.logger.info "[POST] /usuarios - Iniciando creación de un nuevo usuario - Body: #{parametros_usuario}"

  repositorio_usuarios = RepositorioUsuarios.new

  plataforma = Plataforma.new

  begin
    usuario = plataforma.registrar_usuario(email, id_telegram, repositorio_usuarios)
    estado = 201
    cuerpo = { id: usuario.id, email: usuario.email, id_telegram: usuario.id_telegram }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.info "Respuesta => [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"
  enviar_respuesta_nuevo(estado, cuerpo)
end

post '/contenidos' do
  require 'date'

  @body ||= request.body.read
  parametros_contenido = JSON.parse(@body)
  titulo = parametros_contenido['titulo']
  anio = parametros_contenido['anio']
  genero = parametros_contenido['genero']
  tipo = parametros_contenido['tipo']
  cantidad_capitulos = parametros_contenido['cantidad_capitulos']
  fecha_agregado_str = parametros_contenido['fecha_agregado']
  fecha_agregado = fecha_agregado_str ? Date.parse(fecha_agregado_str) : Date.today

  settings.logger.info "[POST] /contenidos - Iniciando creación de un nuevo contenido - Cuerpo: #{parametros_contenido}"

  begin
    repositorio_peliculas = RepositorioPeliculas.new
    pelicula = Plataforma.new.registrar_contenido(titulo, anio, genero, repositorio_peliculas, fecha_agregado, tipo, cantidad_capitulos)
    estado = 201
    cuerpo = { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.info "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"
  enviar_respuesta_nuevo(estado, cuerpo)
end

get '/contenidos' do
  titulo = params['titulo']

  repositorio_peliculas = RepositorioPeliculas.new
  peliculas = Plataforma.new.obtener_contenido_por_titulo(titulo, repositorio_peliculas)

  status 200
  response = []
  peliculas.each do |pelicula|
    response << { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero }
  end
  response.to_json
end

post '/visualizaciones' do
  @body ||= request.body.read
  parametros_visualizaciones = JSON.parse(@body)
  email = parametros_visualizaciones['email']
  id_pelicula = parametros_visualizaciones['id_pelicula']
  fecha = parametros_visualizaciones['fecha']

  settings.logger.info "[POST] /visualizaciones - Iniciando creación de una nueva visualizacion - Body: #{parametros_visualizaciones}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_peliculas = RepositorioPeliculas.new
  repositorio_visualizaciones = RepositorioVisualizaciones.new

  begin
    visualizacion = Plataforma.new(nil, id_pelicula).registrar_visualizacion(repositorio_usuarios, repositorio_peliculas, repositorio_visualizaciones, email, fecha)
    estado = 201
    cuerpo = { id: visualizacion.id, email: visualizacion.usuario.email, id_pelicula: visualizacion.pelicula.id, fecha: visualizacion.fecha.iso8601 }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.info "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"
  enviar_respuesta_nuevo(estado, cuerpo)
end

get '/visualizaciones/top' do
  settings.logger.info '[GET] /visualizacion/top - Consultando las visualizaciones existentes'

  repositorio_visualizaciones = RepositorioVisualizaciones.new

  begin
    contenidos_mas_vistos = Plataforma.new.obtener_visualizacion_mas_vistos(repositorio_visualizaciones)
    estado = 200
    cuerpo = contenidos_mas_vistos
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.info "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"
  enviar_respuesta_nuevo(estado, cuerpo)
end

post '/calificaciones' do
  @body ||= request.body.read
  parametros_calificaciones = JSON.parse(@body)
  id_telegram = parametros_calificaciones['id_telegram']
  id_pelicula = parametros_calificaciones['id_pelicula']
  puntaje = parametros_calificaciones['puntaje']

  settings.logger.info "[POST] /calificaciones - Iniciando creación de una nueva calificion - Body: #{parametros_calificaciones}"

  repositorio_contenidos = RepositorioPeliculas.new
  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_visualizaciones = RepositorioVisualizaciones.new
  repositorio_calificaciones = RepositorioCalificaciones.new

  plataforma = Plataforma.new(id_telegram, id_pelicula)

  begin
    calificacion, puntaje_anterior = plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
    estado, respuesta = armar_respuesta_calificaciones(calificacion, puntaje_anterior)
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    respuesta = error_response.respuesta
  end

  settings.logger.info "Respuesta - [Estado] : #{estado} - [Cuerpo] : #{respuesta}"
  enviar_respuesta_nuevo(estado, respuesta)
end

def armar_respuesta_calificaciones(calificacion, puntaje_anterior)
  if puntaje_anterior.nil?
    estado = 201
    respuesta = { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_pelicula: calificacion.pelicula.id, puntaje: calificacion.puntaje }
  else
    estado = 200
    respuesta = { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_pelicula: calificacion.pelicula.id, puntaje: calificacion.puntaje, puntaje_anterior: }
  end
  [estado, respuesta]
end

post '/favoritos' do
  @body ||= request.body.read
  parametros_favoritos = JSON.parse(@body)
  id_telegram = parametros_favoritos['id_telegram']
  id_contenido = parametros_favoritos['id_contenido']

  settings.logger.info "[POST] /favoritos - Iniciando creación de un nuevo contenido favorito - Body: #{parametros_favoritos}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_peliculas = RepositorioPeliculas.new
  repositorio_favoritos = RepositorioFavoritos.new

  plataforma = Plataforma.new(id_telegram, id_contenido)

  begin
    favorito = plataforma.registrar_favorito(repositorio_usuarios, repositorio_peliculas, repositorio_favoritos)
    estado = 201
    respuesta = { id: favorito.id, id_telegram:, id_contenido: }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    respuesta = error_response.respuesta
  end

  settings.logger.info "[Status] : #{estado} - [Response] : #{respuesta}"
  enviar_respuesta_nuevo(estado, respuesta)
end

get '/favoritos' do
  id_telegram = params['id_telegram']
  usuario = RepositorioUsuarios.new.find_by_id_telegram(id_telegram)

  favoritos = RepositorioFavoritos.new.find_by_user(usuario.id)

  status 200
  response = []

  favoritos.each do |favorito|
    response << { id: favorito.contenido.id, titulo: favorito.contenido.titulo, anio: favorito.contenido.anio, genero: favorito.contenido.genero }
  end

  response.to_json
end

get '/contenidos/ultimos-agregados' do
  settings.logger.info '[GET] /contenidos/ultimos-agregados - Consultando los ultimos contenidos agregados de la semana'

  repositorio_peliculas = RepositorioPeliculas.new

  plataforma = Plataforma.new

  contenidos = plataforma.obtener_contenido_ultimos_agregados(repositorio_peliculas)

  respuesta = []
  contenidos.each do |contenido|
    respuesta << { id: contenido.id, titulo: contenido.titulo, anio: contenido.anio, genero: contenido.genero }
  end

  estado = 200

  enviar_respuesta_nuevo(estado, respuesta)
end

get '/contenidos/:id_contenido/detalles' do
  id_telegram = params['id_telegram']
  id_contenido = params['id_contenido']

  settings.logger.info "[GET] /contenidos/#{id_contenido}/detalles - Consultando los detalles acerca de la pelicula con id: #{id_contenido}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_contenidos = RepositorioPeliculas.new
  repositorio_visualizaciones = RepositorioVisualizaciones.new

  omb_conector_api = OMDbConectorAPIProxy.new

  plataforma = Plataforma.new(id_telegram, id_contenido)
  omdb_respuesta, fue_visto = plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omb_conector_api)

  respuesta = armar_respuesta_omdb(omdb_respuesta, fue_visto)

  logger.info "[Status] : 200 - [Response] : #{respuesta}"

  status 200
  respuesta
rescue ErrorPeliculaInexistente
  armar_error('no encontrado')
rescue StandardError => e
  armar_error(e.message)
end

def armar_error(mensaje)
  settings.logger.error "[Status] : 404 - [Response] : 'no encontrado' - [Mensaje] '#{mensaje}'"
  status 404
  {
    error: mensaje
  }.to_json
end

def armar_respuesta_omdb(omdb_respuesta, fue_visto)
  detalles_pelicula = omdb_respuesta['cuerpo']

  respuesta = {
    titulo: detalles_pelicula['Title'],
    anio: detalles_pelicula['Year'],
    premios: detalles_pelicula['Awards'],
    director: detalles_pelicula['Director'],
    sinopsis: detalles_pelicula['Plot']
  }

  respuesta[:fue_visto] = fue_visto unless fue_visto.nil?

  respuesta.to_json
end
