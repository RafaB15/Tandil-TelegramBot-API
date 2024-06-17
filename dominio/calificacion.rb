class Calificacion
  attr_reader :created_on, :updated_on, :usuario, :pelicula, :puntaje
  attr_accessor :id

  def initialize(usuario, pelicula, puntaje, id = nil)
    raise ErrorAlInstanciarCalificacionInvalida unless es_el_puntaje_valido?(puntaje)

    @usuario = usuario
    @pelicula = pelicula
    @puntaje = puntaje
    @id = id
  end

  def recalificar(puntaje_nuevo)
    raise ErrorAlInstanciarCalificacionInvalida unless es_el_puntaje_valido?(puntaje_nuevo)

    puntaje_anterior = @puntaje
    @puntaje = puntaje_nuevo
    puntaje_anterior
  end

  private

  def es_el_puntaje_valido?(puntaje)
    puntaje > 0 && puntaje < 6
  end
end

class ErrorAlInstanciarCalificacionInvalida < ArgumentError
  MSG_DE_ERROR = 'Error: calificacion invalida'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
