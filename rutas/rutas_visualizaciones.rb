require 'sinatra'

require_relative './utiles'

post '/visualizaciones' do
  @body ||= request.body.read
  parametros_visualizaciones = JSON.parse(@body)
  email = parametros_visualizaciones['email']
  id_pelicula = parametros_visualizaciones['id_pelicula']
  fecha = parametros_visualizaciones['fecha']
  numero_capitulo = parametros_visualizaciones['numero_capitulo']

  settings.logger.debug "[POST] /visualizaciones - Iniciando creación de una nueva visualizacion - Body: #{parametros_visualizaciones}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_contenidos = RepositorioContenidos.new
  repositorio_visualizaciones = RepositorioVisualizaciones.new
  repositorio_visualizaciones_de_capitulos = RepositorioVisualizacionesDeCapitulos.new

  begin
    visualizacion = Plataforma.new(nil, id_pelicula).registrar_visualizacion(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, repositorio_visualizaciones_de_capitulos,
                                                                             numero_capitulo, email, fecha)
    estado, cuerpo = armar_respuesta_cargar_visualizacion(visualizacion, numero_capitulo)
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

get '/visualizaciones/top' do
  settings.logger.debug '[GET] /visualizacion/top - Consultando las visualizaciones existentes'

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

  settings.logger.debug "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end

def armar_respuesta_cargar_visualizacion(visualizacion, numero_capitulo)
  estado = 201
  respuesta = if numero_capitulo.nil?
                { id: visualizacion.id, email: visualizacion.usuario.email, id_pelicula: visualizacion.pelicula.id, fecha: visualizacion.fecha.iso8601 }
              else
                { id: visualizacion.id, email: visualizacion.usuario.email, id_contenido: visualizacion.temporada_de_serie.id, fecha: visualizacion.fecha.iso8601,
                  numero_capitulo: visualizacion.numero_capitulo }
              end
  [estado, respuesta]
end
