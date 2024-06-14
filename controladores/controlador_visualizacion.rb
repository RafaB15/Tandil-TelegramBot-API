class ControladorVisualizacion < ControladorBase
  def crear_visualizacion(creador_de_visualizacion)
    visualizacion = creador_de_visualizacion.crear
    generar_respuesta(201, { id: visualizacion.id, email: visualizacion.usuario.email, id_pelicula: visualizacion.pelicula.id, fecha: visualizacion.fecha.iso8601 })
  rescue StandardError => e
    mapeo = ManejadorDeErrores.new(e)
    generar_respuesta_error(mapeo)
  end
end
