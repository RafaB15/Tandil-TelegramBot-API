require_relative './controlador_base'

class ControladorContenido < ControladorBase
  def crear_pelicula(creador_de_pelicula)
    pelicula = creador_de_pelicula.crear
    generar_respuesta(201, { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero })
  rescue StandardError => e
    mapeo = ManejadorDeErrores.new(e)
    generar_respuesta_error(mapeo)
  end
end
