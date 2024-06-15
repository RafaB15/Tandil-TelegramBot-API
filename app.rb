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

# Crear instancias de los controladores
controlador_calificacion = ControladorCalificacion.new
controlador_mas_vistos = ControladorMasVistos.new
controlador_visualizacion = ControladorVisualizacion.new

# Listo
get '/version' do
  settings.logger.info '[GET] /version - Consultando la version de la API Rest'

  version = Version.current
  cuerpo = { version: }.to_json

  settings.logger.info "Respuesta - [Estado] : 200 - [Cuerpo] : #{cuerpo}"

  status 200
  cuerpo
end

# Listo
post '/reset' do
  settings.logger.info '[POST] /reset - Reinicia la base de datos'

  AbstractRepository.subclasses.each do |repositorio|
    repositorio.new.delete_all
  end

  settings.logger.info 'Respuesta - [Estado] : 200 - [Cuerpo] : vacio'

  status 200
end

# Listo
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

# Listo
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

# Listo
post '/contenidos' do
  require 'date'

  @body ||= request.body.read
  parametros_contenido = JSON.parse(@body)
  titulo = parametros_contenido['titulo']
  anio = parametros_contenido['anio']
  genero = parametros_contenido['genero']
  fecha_agregado_str = parametros_contenido['fecha_agregado']
  fecha_agregado = fecha_agregado_str ? Date.parse(fecha_agregado_str) : Date.today

  settings.logger.info "[POST] /contenidos - Iniciando creación de un nuevo contenido - Cuerpo: #{parametros_contenido}"

  begin
    repositorio_peliculas = RepositorioPeliculas.new
    pelicula = Plataforma.new.registrar_contenido(titulo, anio, genero, repositorio_peliculas, fecha_agregado)
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

## Listo
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

  creador_de_visualizacion = CreadorDeVisualizacion.new(email, id_pelicula, fecha)
  controlador_visualizacion.crear_visualizacion(creador_de_visualizacion)

  settings.logger.info "[Status] : #{controlador_visualizacion.estado} - [Response] : #{controlador_visualizacion.respuesta}"

  enviar_respuesta(controlador_visualizacion)
end

get '/visualizaciones/top' do
  settings.logger.info '[GET] /visualizacion/top - Consultando las visualizaciones existentes'

  visualizaciones = RepositorioVisualizaciones.new.all
  controlador_mas_vistos.obtener_mas_vistos(visualizaciones)

  settings.logger.info "[Status] : #{controlador_mas_vistos.estado} - [Response] : #{controlador_mas_vistos.respuesta}"

  enviar_respuesta(controlador_mas_vistos)
end

## Listo
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
    calificacion = plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
    estado = 201
    respuesta = { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_pelicula: calificacion.pelicula.id, puntaje: calificacion.puntaje }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    respuesta = error_response.respuesta
  end

  settings.logger.info "Respuesta - [Estado] : #{estado} - [Cuerpo] : #{respuesta}"
  enviar_respuesta_nuevo(estado, respuesta)
end

put '/calificaciones' do
  @body ||= request.body.read
  parametros_calificacion = JSON.parse(@body)
  id_telegram = parametros_calificacion['id_telegram']
  id_pelicula = parametros_calificacion['id_pelicula']
  nueva_calificacion = parametros_calificacion['calificacion']

  calificacion = RepositorioCalificaciones.new.find_by_id_usuario_y_id_contenido(id_telegram, id_pelicula)

  RepositorioCalificaciones.new.destroy(calificacion)

  settings.logger.info "[PUT] /calificacion - Actualizando la calificion - Body: #{parametros_calificacion}"

  creador_de_calificacion = CreadorDeCalificacion.new(id_telegram, id_pelicula, nueva_calificacion)
  controlador_calificacion.crear_calificacion(creador_de_calificacion)

  settings.logger.info "[Status] : #{controlador_calificacion.estado} - [Response] : #{controlador_calificacion.respuesta}"

  enviar_respuesta(controlador_calificacion)
end

## Listo
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

## Listo
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

  contenidos = RepositorioPeliculas.new.ultimos_agregados

  top_5_contenidos = contenidos.sort_by { |contenido| [-contenido.fecha_agregado.to_time.to_i, contenido.titulo] }.first(5)

  status 200
  response = []
  top_5_contenidos.each do |contenido|
    response << { id: contenido.id, titulo: contenido.titulo, anio: contenido.anio, genero: contenido.genero }
  end

  response.to_json
end

get '/contenidos/:id_contenido/detalles' do
  id_telegram = params['id_telegram']
  id_contenido = params['id_contenido']

  settings.logger.info "[GET] /contenidos/#{id_contenido}/detalles - Consultando los detalles acerca de la pelicula con id: #{id_contenido}"

  pelicula = RepositorioPeliculas.new.find(id_contenido)

  omdb_respuesta = OMDbConectorAPIProxy.new.detallar_pelicula(pelicula.titulo, settings.logger)

  respuesta = armar_respuesta(omdb_respuesta, id_telegram, id_contenido)

  logger.info "[Status] : 200 - [Response] : #{respuesta}"

  status 200
  respuesta
rescue NameError
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

def armar_respuesta(omdb_respuesta, id_telegram, id_contenido)
  detalles_pelicula = omdb_respuesta['cuerpo']

  respuesta = {
    titulo: detalles_pelicula['Title'],
    anio: detalles_pelicula['Year'],
    premios: detalles_pelicula['Awards'],
    director: detalles_pelicula['Director'],
    sinopsis: detalles_pelicula['Plot']
  }

  usuario = RepositorioUsuarios.new.find_by_id_telegram(id_telegram)
  if usuario
    fue_visto = !RepositorioVisualizaciones.new.find_by_id_usuario_y_id_contenido(usuario.id, id_contenido).nil?
    respuesta[:fue_visto] = fue_visto
  end

  respuesta.to_json
end

# class Plataforma #Objeto fachada de aplicación - simil NonaPedidos.

#   def registrar_usuario(email, id_telegram, repo)

#     raise ErrorAlPersistirUsuarioYaExistente unless repo.find_by_id_telegram(id_telegram).nil?
#     usuario = Usuario.new(email, id_telegram) #Verificaciones de validez de email y telegram id van dentro de usuario
#     repo.save(usuario)
#     usuario

#   end
# end

# post '/usuarios' do
#   # rescatar parametros
#   @body ||= request.body.read
#   parametros_usuario = JSON.parse(@body)
#   email = parametros_usuario['email']
#   id_telegram = parametros_usuario['id_telegram']

#   repo = RepositorioUsuarios.new #Objeto de I/O
#   plataforma = Plataforma.new #Objeto de negocio
#   usuario = plataforma.registrar_usuario(email, id_telegram, repo) #Tira error si falla.

#   status 200
#   { id: usuario.id, email: usuario.email, id_telegram: usuario.id_telegram }.to_json #respuesta HTTP correcta
# rescue StandardError => e
#   mapeo = MapeoErrorAHTTP.new(e) #Entidad que sabe los errores del negocio y mapea al error HTTP correspondiente
#   #Ahora el manejador guarda en sus atributos lo necesario para pasarse al generador y que este arme un error HTTP

#   error_http = ErrorHTTP.new(mapeo) #Este objeto recibe un manejador con los datos necesarios en sus atributos
#   status error_http.estado
#   error_http.respuesta #Genera el error HTTP como json
# end
