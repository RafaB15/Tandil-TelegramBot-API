require 'sinatra'

require_relative './utiles'

post '/calificaciones' do
  @body ||= request.body.read
  parametros_calificaciones = JSON.parse(@body)
  id_telegram = parametros_calificaciones['id_telegram']
  id_contenido = parametros_calificaciones['id_contenido']
  puntaje = parametros_calificaciones['puntaje']

  settings.logger.debug "[POST] /calificaciones - Iniciando creación de una nueva calificion - Body: #{parametros_calificaciones}"

  repositorio_contenidos = RepositorioContenidos.new
  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_visualizaciones = RepositorioVisualizaciones.new
  repositorio_calificaciones = RepositorioCalificaciones.new
  repositorio_visualizaciones_de_capitulos = RepositorioVisualizacionesDeCapitulos.new

  plataforma = Plataforma.new(id_telegram, id_contenido)

  begin
    calificacion, puntaje_anterior = plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones,
                                                                       repositorio_visualizaciones_de_capitulos)

    estado, cuerpo = armar_respuesta_calificaciones(calificacion, puntaje_anterior)
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

def armar_respuesta_calificaciones(calificacion, puntaje_anterior)
  if puntaje_anterior.nil?
    estado = 201
    respuesta = { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_contenido: calificacion.pelicula.id, puntaje: calificacion.puntaje }
  else
    estado = 200
    respuesta = { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_contenido: calificacion.pelicula.id, puntaje: calificacion.puntaje, puntaje_anterior: }
  end
  [estado, respuesta]
end
