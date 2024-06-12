class ErrorAlInstanciarCalificacionInvalida < ArgumentError
  MSG_DE_ERROR = 'Error: calificacion invalida'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class CreadorDeCalificacion
  def initialize(id_telegram, id_pelicula, calificacion)
    @id_telegram = id_telegram
    @id_pelicula = id_pelicula
    @calificacion = calificacion
  end

  # TODO: chequear que exista la visualizacion para esta calificacion
  def crear
    raise ErrorAlInstanciarCalificacionInvalida unless es_la_calificacion_valida?

    usuario = RepositorioUsuarios.new.find_by_id_telegram(@id_telegram)
    pelicula = RepositorioPeliculas.new.find(@id_pelicula)

    calificacion = Calificacion.new(usuario, pelicula, @calificacion)

    RepositorioCalificaciones.new.save(calificacion)

    calificacion
  rescue StandardError => _e
    raise
  end

  private

  def es_la_calificacion_valida?
    @calificacion > 0
  end
end
