require_relative './controlador_base'

class ControladorContenido < ControladorBase
  def crear_pelicula(creador_de_pelicula)
    pelicula = creador_de_pelicula.crear
    generar_respuesta(201, { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero })
  rescue StandardError => e
    error_info = ManejadorDeErrores.new.manejar_error(e)
    generar_respuesta_error(error_info[:estado], error_info[:campo], error_info[:mensaje])
  end
end
