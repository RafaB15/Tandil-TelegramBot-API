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
  version = Version.current
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.enviar_version(version)

  enviar_respuesta(generador_de_respuestas_http)
end

post '/reset' do
  RepositorioUsuarios.new.delete_all
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.reiniciar_usuarios

  enviar_respuesta(generador_de_respuestas_http)
end

get '/usuarios' do
  usuarios = RepositorioUsuarios.new.all
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.enviar_usuarios(usuarios)

  enviar_respuesta(generador_de_respuestas_http)
end

post '/usuarios' do
  @body ||= request.body.read
  parametros_usuario = JSON.parse(@body)
  email = parametros_usuario['email']
  telegram_id = parametros_usuario['telegram_id']

  creador_de_usuario = CreadorDeUsuario.new(email, telegram_id)

  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.crear_usuario(creador_de_usuario)

  enviar_respuesta(generador_de_respuestas_http)
end

post '/contenido' do
  @body ||= request.body.read
  parametros_contenido = JSON.parse(@body)
  titulo = parametros_contenido['titulo']
  anio = parametros_contenido['anio']
  genero = parametros_contenido['genero']

  creador_de_pelicula = CreadorDePelicula.new(titulo, anio, genero)
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.crear_pelicula(creador_de_pelicula)

  enviar_respuesta(generador_de_respuestas_http)
end

post '/visualizacion' do
  @body ||= request.body.read
  parametros_visualizacion = JSON.parse(@body)
  id_usuario = parametros_visualizacion['id_usuario']
  id_pelicula = parametros_visualizacion['id_pelicula']
  fecha = parametros_visualizacion['fecha']

  creador_de_visualizacion = CreadorDeVisualizacion.new(id_usuario, id_pelicula, fecha)
  generador_de_respuestas_http = GeneradorDeRespuestasHTTP.new
  generador_de_respuestas_http.crear_visualizacion(creador_de_visualizacion)

  enviar_respuesta(generador_de_respuestas_http)
end
