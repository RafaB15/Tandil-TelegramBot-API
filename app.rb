require 'sinatra'
require 'sequel'
require 'sinatra/custom_logger'
require_relative './config/configuration'
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'dominio', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'persistencia', '*.rb')].each { |file| require file }

customer_logger = Configuration.logger
set :logger, customer_logger
DB = Configuration.db
DB.loggers << customer_logger

def enviar_respuesta(generador_de_respuestas_http)
  status(generador_de_respuestas_http.estado)
  generador_de_respuestas_http.respuesta
end

get '/version' do
  settings.logger.info '[GET] /version - Consultando la version de la API Rest'

  version = Version.current
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.enviar_version(version)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

post '/reset' do
  settings.logger.info '[POST] /reset - Reinicia la base de datos'

  RepositorioUsuarios.new.delete_all
  RepositorioPeliculas.new.delete_all
  RepositorioVisualizaciones.new.delete_all

  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.reiniciar_usuarios

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

get '/usuarios' do
  settings.logger.info '[GET] /usuarios - Consultando los usuarios registrados'

  usuarios = RepositorioUsuarios.new.all
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.enviar_usuarios(usuarios)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

post '/usuarios' do
  @body ||= request.body.read
  parametros_usuario = JSON.parse(@body)
  email = parametros_usuario['email']
  id_telegram = parametros_usuario['id_telegram']

  settings.logger.info "[POST] /usuarios - Iniciando creación de un nuevo usuario - Body: #{parametros_usuario}"

  creador_de_usuario = CreadorDeUsuario.new(email, id_telegram)

  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.crear_usuario(creador_de_usuario)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

post '/contenido' do
  @body ||= request.body.read
  parametros_contenido = JSON.parse(@body)
  titulo = parametros_contenido['titulo']
  anio = parametros_contenido['anio']
  genero = parametros_contenido['genero']

  settings.logger.info "[POST] /contenido - Iniciando creación de un nuevo contenido - Body: #{parametros_contenido}"

  creador_de_pelicula = CreadorDePelicula.new(titulo, anio, genero)
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.crear_pelicula(creador_de_pelicula)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

post '/visualizacion' do
  @body ||= request.body.read
  parametros_visualizacion = JSON.parse(@body)
  email = parametros_visualizacion['email']
  id_pelicula = parametros_visualizacion['id_pelicula']
  fecha = parametros_visualizacion['fecha']

  settings.logger.info "[POST] /visualizacion - Iniciando creación de una nueva visualizacion - Body: #{parametros_visualizacion}"

  creador_de_visualizacion = CreadorDeVisualizacion.new(email, id_pelicula, fecha)
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.crear_visualizacion(creador_de_visualizacion)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

get '/visualizacion/top' do
  settings.logger.info '[GET] /visualizacion/top - Consultando las visualizaciones existentes'

  visualizaciones = RepositorioVisualizaciones.new.all
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.obtener_mas_vistos(visualizaciones)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

post '/calificacion' do
  @body ||= request.body.read
  parametros_calificacion = JSON.parse(@body)
  id_telegram = parametros_calificacion['id_telegram']
  id_pelicula = parametros_calificacion['id_pelicula']
  calificacion = parametros_calificacion['calificacion']

  settings.logger.info "[POST] /calificacion - Iniciando creación de una nueva calificion - Body: #{parametros_calificacion}"

  creador_de_calificacion = CreadorDeCalificacion.new(id_telegram, id_pelicula, calificacion)

  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.crear_calificacion(creador_de_calificacion)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end

post '/favorito' do
  @body ||= request.body.read
  parametros_calificacion = JSON.parse(@body)
  id_telegram = parametros_calificacion['id_telegram']
  id_contenido = parametros_calificacion['id_contenido']

  creador_de_favorito = CreadorDeFavorito.new(id_telegram, id_contenido)

  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.aniadir_favorito(creador_de_favorito)

  settings.logger.info "[Status] : #{generador_de_respuestas_http.estado} - [Response] : #{generador_de_respuestas_http.respuesta}"

  enviar_respuesta(generador_de_respuestas_http)
end
