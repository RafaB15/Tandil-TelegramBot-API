class ControladorContenido < ControladorBase
  def crear_pelicula(creador_de_pelicula)
    pelicula = creador_de_pelicula.crear
    generar_respuesta(201, { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero })
  rescue StandardError => e
    ManejadorDeErrores.new.manejar_error(e)
  end
end
