require 'sinatra'

require_relative './utiles'
Dir[File.join(__dir__, '../lib/om_db_conector_api', '*.rb')].each { |file| require file }

post '/contenidos' do
  require 'date'
  @body ||= request.body.read
  parametros_contenidos = JSON.parse(@body)
  titulo, anio, genero, cantidad_capitulos, fecha_agregado, tipo = parametros_contenidos.values_at('titulo', 'anio', 'genero', 'cantidad_capitulos', 'fecha_agregado', 'tipo')
  fecha_agregado = fecha_agregado ? Date.parse(fecha_agregado) : Date.today

  settings.logger.debug "[POST] /contenidos - Iniciando creación de un nuevo contenido - Cuerpo: #{parametros_contenidos}"

  repositorio_contenidos = tipo == 'serie' ? RepositorioTemporadasDeSeries.new : RepositorioPeliculas.new
  raise ArgumentError, "Valor inválido para tipo de contenido: #{tipo}" unless %w[serie pelicula].include?(tipo)

  begin
    contenido = Plataforma.new.registrar_contenido(titulo, anio, genero, repositorio_contenidos, tipo, fecha_agregado, cantidad_capitulos)

    estado = 201
    cuerpo = { id: contenido.id, titulo: contenido.titulo, anio: contenido.anio, genero: contenido.genero, tipo:, fecha_agregado: contenido.fecha_agregado }
    cuerpo[:cantidad_capitulos] = contenido.cantidad_capitulos if tipo == 'serie'
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)

    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.debug "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end

get '/contenidos' do
  titulo = params['titulo']

  settings.logger.debug '[GET] /contenidos - Consultando los contenidos guardados en la BDD'

  repositorio_contenidos = RepositorioContenidos.new
  contenidos = Plataforma.new.obtener_contenido_por_titulo(titulo, repositorio_contenidos)

  estado = 200
  cuerpo = []

  contenidos.each do |contenido|
    cuerpo << { id: contenido.id, titulo: contenido.titulo, anio: contenido.anio, genero: contenido.genero }
  end

  settings.logger.debug "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end

get '/contenidos/ultimos-agregados' do
  settings.logger.debug '[GET] /contenidos/ultimos-agregados - Consultando los ultimos contenidos agregados de la semana'

  repositorio_contenidos = RepositorioContenidos.new

  plataforma = Plataforma.new

  contenidos = plataforma.obtener_contenido_ultimos_agregados(repositorio_contenidos)

  estado = 200
  cuerpo = []

  contenidos.each do |contenido|
    cuerpo << { id: contenido.id, titulo: contenido.titulo, anio: contenido.anio, genero: contenido.genero }
  end

  settings.logger.debug "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end

get '/contenidos/:id_contenido/detalles' do
  id_telegram = params['id_telegram']
  id_contenido = params['id_contenido']

  settings.logger.debug "[GET] /contenidos/#{id_contenido}/detalles - Consultando los detalles acerca de la pelicula con id: #{id_contenido}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_contenidos = RepositorioContenidos.new
  repositorio_visualizaciones = RepositorioVisualizaciones.new

  api_detalles_conector = OMDbConectorAPIProxy.new

  plataforma = Plataforma.new(id_telegram, id_contenido)

  begin
    detalles_de_contenido = plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, api_detalles_conector)

    estado = 200
    cuerpo = armar_respuesta_omdb(detalles_de_contenido)
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)

    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.debug "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end

def armar_respuesta_omdb(detalles_de_contenido)
  respuesta = Hash.new(0)
  mapeo_de_detalles = {
    'titulo' => :titulo,
    'anio' => :anio,
    'premios' => :premios,
    'director' => :director,
    'sinopsis' => :sinopsis
  }

  mapeo_de_detalles.each do |campo_detalle, metodo|
    valor = detalles_de_contenido.send(metodo)
    respuesta[campo_detalle] = valor unless valor.nil?
  end

  respuesta['fue_visto'] = detalles_de_contenido.fue_visto unless detalles_de_contenido.fue_visto.nil?

  respuesta
end
