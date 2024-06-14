class Calificacion
  attr_reader :created_on, :updated_on, :usuario, :pelicula, :calificacion
  attr_accessor :id

  def initialize(usuario, pelicula, calificacion, id = nil)
    @usuario = usuario
    @pelicula = pelicula
    @calificacion = calificacion
    @id = id
    raise ErrorAlInstanciarCalificacionInvalida unless son_los_parametros_validos?
  end

  private

  def son_los_parametros_validos?
    @calificacion > 0 && @calificacion < 6
  end
end

class ErrorAlInstanciarCalificacionInvalida < ArgumentError
  MSG_DE_ERROR = 'Error: calificacion invalida'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
