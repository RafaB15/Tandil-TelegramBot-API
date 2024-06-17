require_relative './utiles'
Dir[File.join(__dir__, '../lib/om_db_conector_api', '*.rb')].each { |file| require file }

post '/contenidos' do
  require 'date'

  @body ||= request.body.read
  parametros_contenidos = JSON.parse(@body)
  titulo = parametros_contenidos['titulo']
  anio = parametros_contenidos['anio']
  genero = parametros_contenidos['genero']
  cantidad_capitulos = parametros_contenidos['cantidad_capitulos']
  fecha_agregado_str = parametros_contenidos['fecha_agregado']
  fecha_agregado = fecha_agregado_str ? Date.parse(fecha_agregado_str) : Date.today

  settings.logger.info "[POST] /contenidos - Iniciando creación de un nuevo contenido - Cuerpo: #{parametros_contenidos}"

  begin
    repositorio_peliculas = RepositorioContenidos.new
    contenido = Plataforma.new.registrar_contenido(titulo, anio, genero, repositorio_peliculas, fecha_agregado, cantidad_capitulos)
    estado = 201
    cuerpo = { id: contenido.id, titulo: contenido.titulo, anio: contenido.anio, genero: contenido.genero, cantidad_capitulos: contenido.cantidad_capitulos }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.info "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"
  enviar_respuesta(estado, cuerpo)
end

get '/contenidos' do
  titulo = params['titulo']

  repositorio_peliculas = RepositorioContenidos.new
  peliculas = Plataforma.new.obtener_contenido_por_titulo(titulo, repositorio_peliculas)

  status 200
  response = []
  peliculas.each do |pelicula|
    response << { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero }
  end
  response.to_json
end

get '/contenidos/ultimos-agregados' do
  settings.logger.info '[GET] /contenidos/ultimos-agregados - Consultando los ultimos contenidos agregados de la semana'

  repositorio_peliculas = RepositorioContenidos.new

  plataforma = Plataforma.new

  contenidos = plataforma.obtener_contenido_ultimos_agregados(repositorio_peliculas)

  respuesta = []
  contenidos.each do |contenido|
    respuesta << { id: contenido.id, titulo: contenido.titulo, anio: contenido.anio, genero: contenido.genero }
  end

  estado = 200

  enviar_respuesta(estado, respuesta)
end

get '/contenidos/:id_contenido/detalles' do
  id_telegram = params['id_telegram']
  id_contenido = params['id_contenido']

  settings.logger.info "[GET] /contenidos/#{id_contenido}/detalles - Consultando los detalles acerca de la pelicula con id: #{id_contenido}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_contenidos = RepositorioContenidos.new
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
