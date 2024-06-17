require_relative './utiles'

post '/visualizaciones' do
  @body ||= request.body.read
  parametros_visualizaciones = JSON.parse(@body)
  email = parametros_visualizaciones['email']
  id_pelicula = parametros_visualizaciones['id_pelicula']
  fecha = parametros_visualizaciones['fecha']

  settings.logger.info "[POST] /visualizaciones - Iniciando creación de una nueva visualizacion - Body: #{parametros_visualizaciones}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_peliculas = RepositorioContenidos.new
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
  enviar_respuesta(estado, cuerpo)
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
  enviar_respuesta(estado, cuerpo)
end
