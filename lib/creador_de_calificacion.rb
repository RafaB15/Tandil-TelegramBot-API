class CreadorDeCalificacion
  def initialize(id_telegram, id_pelicula, calificacion)
    @id_telegram = id_telegram
    @id_pelicula = id_pelicula
    @calificacion = calificacion
  end

  # TODO: chequear que exista la visualizacion para esta calificacion
  def crear
    usuario = RepositorioUsuarios.new.find_by_id_telegram(@id_telegram)
    pelicula = RepositorioPeliculas.new.find(@id_pelicula)

    calificacion = Calificacion.new(usuario, pelicula, @calificacion)

    RepositorioCalificaciones.new.save(calificacion)

    calificacion
  rescue StandardError => _e
    raise
  end
end
