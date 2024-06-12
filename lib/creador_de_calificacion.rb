class ErrorAlInstanciarCalificacionInvalida < ArgumentError
  MSG_DE_ERROR = 'Error: calificacion invalida'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class CreadorDeCalificacion
  def initialize(id_telegram, id_pelicula, calificacion)
    @id_telegram = id_telegram
    @id_pelicula = id_pelicula
    @calificacion = calificacion
  end

  def crear
    raise ErrorAlInstanciarCalificacionInvalida unless es_la_calificacion_valida?

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

  private

  def es_la_calificacion_valida?
    @calificacion > 0 && @calificacion < 6
  end
end
