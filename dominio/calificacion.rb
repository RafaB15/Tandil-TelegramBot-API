class Calificacion
  attr_reader :created_on, :updated_on, :usuario, :pelicula, :puntaje
  attr_accessor :id

  def initialize(usuario, pelicula, puntaje, id = nil)
    @usuario = usuario
    @pelicula = pelicula
    @puntaje = puntaje
    @id = id

    raise ErrorAlInstanciarCalificacionInvalida unless son_los_parametros_validos?
  end

  def es_una_recalificacion?(repositorio_calificaciones)
    calificacion = repositorio_calificaciones.find_by_id_usuario_y_id_contenido(@usuario.id, @pelicula.id)
    if calificacion
      repositorio_calificaciones.destroy(calificacion)
      true
    end
    false
  end

  private

  def son_los_parametros_validos?
    @puntaje > 0 && @puntaje < 6
  end
end

class ErrorAlInstanciarCalificacionInvalida < ArgumentError
  MSG_DE_ERROR = 'Error: calificacion invalida'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
