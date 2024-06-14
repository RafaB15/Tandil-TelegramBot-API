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
controlador_usuarios = ControladorUsuarios.new
controlador_contenido = ControladorContenido.new
controlador_calificacion = ControladorCalificacion.new
controlador_mas_vistos = ControladorMasVistos.new
controlador_visualizacion = ControladorVisualizacion.new
controlador_version = ControladorVersion.new

get '/version' do
  settings.logger.info '[GET] /version - Consultando la version de la API Rest'

  version = Version.current
  controlador_version.enviar_version(version)

  settings.logger.info "[Status] : #{controlador_version.estado} - [Response] : #{controlador_version.respuesta}"

  enviar_respuesta(controlador_version)
end

post '/reset' do
  settings.logger.info '[POST] /reset - Reinicia la base de datos'

  AbstractRepository.subclasses.each do |repositorio|
    repositorio.new.delete_all
  end

  controlador_usuarios.reiniciar_usuarios

  settings.logger.info "[Status] : #{controlador_usuarios.estado} - [Response] : #{controlador_usuarios.respuesta}"

  enviar_respuesta(controlador_usuarios)
end

get '/usuarios' do
  settings.logger.info '[GET] /usuarios - Consultando los usuarios registrados'

  usuarios = RepositorioUsuarios.new.all
  controlador_usuarios.enviar_usuarios(usuarios)

  settings.logger.info "[Status] : #{controlador_usuarios.estado} - [Response] : #{controlador_usuarios.respuesta}"

  enviar_respuesta(controlador_usuarios)
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
    respuesta = { id: usuario.id, email: usuario.email, id_telegram: usuario.id_telegram }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    respuesta = error_response.respuesta
  end

  settings.logger.info "[Status] : #{estado} - [Response] : #{respuesta}"
  enviar_respuesta_nuevo(estado, respuesta)
end

post '/contenido' do
  require 'date'

  @body ||= request.body.read
  parametros_contenido = JSON.parse(@body)
  titulo = parametros_contenido['titulo']
  anio = parametros_contenido['anio']
  genero = parametros_contenido['genero']
  fecha_agregado_str = parametros_contenido['fecha_agregado']
  fecha_agregado = fecha_agregado_str ? Date.parse(fecha_agregado_str) : Date.today

  settings.logger.info "[POST] /contenido - Iniciando creación de un nuevo contenido - Body: #{parametros_contenido}"

  creador_de_pelicula = CreadorDePelicula.new(titulo, anio, genero, fecha_agregado)
  controlador_contenido.crear_pelicula(creador_de_pelicula)

  settings.logger.info "[Status] : #{controlador_contenido.estado} - [Response] : #{controlador_contenido.respuesta}"

  enviar_respuesta(controlador_contenido)
end

get '/contenido' do
  titulo = params['titulo']

  peliculas = RepositorioPeliculas.new.find_by_title(titulo)
  status 200
  response = []
  peliculas.each do |pelicula|
    response << { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero }
  end
  response.to_json
end

post '/visualizacion' do
  @body ||= request.body.read
  parametros_visualizacion = JSON.parse(@body)
  email = parametros_visualizacion['email']
  id_pelicula = parametros_visualizacion['id_pelicula']
  fecha = parametros_visualizacion['fecha']

  settings.logger.info "[POST] /visualizacion - Iniciando creación de una nueva visualizacion - Body: #{parametros_visualizacion}"

  creador_de_visualizacion = CreadorDeVisualizacion.new(email, id_pelicula, fecha)
  controlador_visualizacion.crear_visualizacion(creador_de_visualizacion)

  settings.logger.info "[Status] : #{controlador_visualizacion.estado} - [Response] : #{controlador_visualizacion.respuesta}"

  enviar_respuesta(controlador_visualizacion)
end

get '/visualizacion/top' do
  settings.logger.info '[GET] /visualizacion/top - Consultando las visualizaciones existentes'

  visualizaciones = RepositorioVisualizaciones.new.all
  controlador_mas_vistos.obtener_mas_vistos(visualizaciones)

  settings.logger.info "[Status] : #{controlador_mas_vistos.estado} - [Response] : #{controlador_mas_vistos.respuesta}"

  enviar_respuesta(controlador_mas_vistos)
end

## Lista
post '/calificacion' do
  @body ||= request.body.read
  parametros_calificacion = JSON.parse(@body)
  id_telegram = parametros_calificacion['id_telegram']
  id_pelicula = parametros_calificacion['id_pelicula']
  calificacion = parametros_calificacion['calificacion']

  settings.logger.info "[POST] /calificacion - Iniciando creación de una nueva calificion - Body: #{parametros_calificacion}"

  repositorio_contenidos = RepositorioPeliculas.new
  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_visualizaciones = RepositorioVisualizaciones.new
  repositorio_calificaciones = RepositorioCalificaciones.new

  plataforma = Plataforma.new(id_telegram, id_pelicula)

  begin
    calificacion = plataforma.registrar_calificacion(calificacion, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
    estado = 201
    respuesta = { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_pelicula: calificacion.pelicula.id, calificacion: calificacion.calificacion }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    respuesta = error_response.respuesta
  end

  settings.logger.info "[Status] : #{estado} - [Response] : #{respuesta}"
  enviar_respuesta_nuevo(estado, respuesta)
end

put '/calificacion' do
  @body ||= request.body.read
  parametros_calificacion = JSON.parse(@body)
  id_telegram = parametros_calificacion['id_telegram']
  id_pelicula = parametros_calificacion['id_pelicula']
  nueva_calificacion = parametros_calificacion['calificacion']

  calificacion = RepositorioCalificaciones.new.find_by_ids_contenido_y_usuario(id_telegram, id_pelicula)

  RepositorioCalificaciones.new.destroy(calificacion)

  settings.logger.info "[PUT] /calificacion - Actualizando la calificion - Body: #{parametros_calificacion}"

  creador_de_calificacion = CreadorDeCalificacion.new(id_telegram, id_pelicula, nueva_calificacion)
  controlador_calificacion.crear_calificacion(creador_de_calificacion)

  settings.logger.info "[Status] : #{controlador_calificacion.estado} - [Response] : #{controlador_calificacion.respuesta}"

  enviar_respuesta(controlador_calificacion)
end

## Listo
post '/favorito' do
  @body ||= request.body.read
  parametros_favorito = JSON.parse(@body)
  id_telegram = parametros_favorito['id_telegram']
  id_contenido = parametros_favorito['id_contenido']

  settings.logger.info "[POST] /favorito - Iniciando creación de un nuevo contenido favorito - Body: #{parametros_favorito}"

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

get '/contenidos/:id_pelicula/detalles' do
  id_telegram = params['id_telegram']
  id_pelicula = params['id_pelicula']

  settings.logger.info "[GET] /contenidos/#{id_pelicula}/detalles - Consultando los detalles acerca de la pelicula con id: #{id_pelicula}"

  pelicula = RepositorioPeliculas.new.find(id_pelicula)

  omdb_respuesta = OMDbConectorAPIProxy.new.detallar_pelicula(pelicula.titulo, settings.logger)

  respuesta = armar_respuesta(omdb_respuesta, id_telegram, id_pelicula)

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

def armar_respuesta(omdb_respuesta, id_telegram, id_pelicula)
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
    fue_visto = !RepositorioVisualizaciones.new.find_by_usuario_y_contenido(usuario.id, id_pelicula).nil?
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
