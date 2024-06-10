require 'sinatra'
require 'sequel'
require 'sinatra/custom_logger'
require_relative './config/configuration'
Dir[File.join(__dir__, 'controladores', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'dominio', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'persistencia', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

customer_logger = Configuration.logger
set :logger, customer_logger
DB = Configuration.db
DB.loggers << customer_logger

def enviar_respuesta(controlador)
  status(controlador.estado)
  controlador.respuesta
end

# Crear instancias de los controladores
controlador_usuarios = ControladorUsuarios.new
controlador_contenido = ControladorContenido.new
controlador_calificacion = ControladorCalificacion.new
controlador_favorito = ControladorFavorito.new
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

  RepositorioUsuarios.new.delete_all
  RepositorioPeliculas.new.delete_all
  RepositorioVisualizaciones.new.delete_all

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

  creador_de_usuario = CreadorDeUsuario.new(email, id_telegram)

  controlador_usuarios.crear_usuario(creador_de_usuario)

  settings.logger.info "[Status] : #{controlador_usuarios.estado} - [Response] : #{controlador_usuarios.respuesta}"

  enviar_respuesta(controlador_usuarios)
end

post '/contenido' do
  @body ||= request.body.read
  parametros_contenido = JSON.parse(@body)
  titulo = parametros_contenido['titulo']
  anio = parametros_contenido['anio']
  genero = parametros_contenido['genero']

  settings.logger.info "[POST] /contenido - Iniciando creación de un nuevo contenido - Body: #{parametros_contenido}"

  creador_de_pelicula = CreadorDePelicula.new(titulo, anio, genero)
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

post '/calificacion' do
  @body ||= request.body.read
  parametros_calificacion = JSON.parse(@body)
  id_telegram = parametros_calificacion['id_telegram']
  id_pelicula = parametros_calificacion['id_pelicula']
  calificacion = parametros_calificacion['calificacion']

  settings.logger.info "[POST] /calificacion - Iniciando creación de una nueva calificion - Body: #{parametros_calificacion}"

  creador_de_calificacion = CreadorDeCalificacion.new(id_telegram, id_pelicula, calificacion)

  controlador_calificacion.crear_calificacion(creador_de_calificacion)

  settings.logger.info "[Status] : #{controlador_calificacion.estado} - [Response] : #{controlador_calificacion.respuesta}"

  enviar_respuesta(controlador_calificacion)
end

post '/favorito' do
  @body ||= request.body.read
  parametros_calificacion = JSON.parse(@body)
  id_telegram = parametros_calificacion['id_telegram']
  id_contenido = parametros_calificacion['id_contenido']

  creador_de_favorito = CreadorDeFavorito.new(id_telegram, id_contenido)

  controlador_favorito.aniadir_favorito(creador_de_favorito)

  settings.logger.info "[Status] : #{controlador_favorito.estado} - [Response] : #{controlador_favorito.respuesta}"

  enviar_respuesta(controlador_favorito)
end
