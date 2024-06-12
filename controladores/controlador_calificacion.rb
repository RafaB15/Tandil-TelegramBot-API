class ControladorCalificacion < ControladorBase
  def crear_calificacion(creador_de_calificacion)
    calificacion = creador_de_calificacion.crear
    generar_respuesta(201, { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_pelicula: calificacion.pelicula.id, calificacion: calificacion.calificacion })
  rescue StandardError => e
    error_info = ManejadorDeErrores.new.manejar_error(e)
    generar_respuesta_error(error_info[:estado], error_info[:campo], error_info[:mensaje])
  end
end
