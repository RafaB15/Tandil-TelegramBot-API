class CreadorDeCalificacion
  def initialize(id_telegram, id_pelicula, calificacion)
    @id_telegram = id_telegram
    @id_pelicula = id_pelicula
    @calificacion = calificacion
  end

  def crear
    begin
      pelicula = RepositorioPeliculas.new.find(@id_pelicula)
    rescue NameError
      raise ErrorPeliculaInexistente
    end

    usuario = RepositorioUsuarios.new.find_by_id_telegram(@id_telegram)

    calificacion = Calificacion.new(usuario, pelicula, @calificacion)

    RepositorioCalificaciones.new.save(calificacion)

    calificacion
  end
end
