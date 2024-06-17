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

  def recalificar(puntaje_nuevo)
    puntaje_anterior = @puntaje
    @puntaje = puntaje_nuevo
    puntaje_anterior
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
