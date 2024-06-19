require_relative 'contenido'

class TemporadaDeSerie < Contenido
  attr_reader :cantidad_capitulos

  def initialize(titulo, anio_de_estreno, genero, cantidad_capitulos, fecha_agregado = Date.today, id = nil)
    raise ErrorAlInstanciarCantidadDeCapitulosInvalido unless es_el_cantidad_de_capitulos_valido?(cantidad_capitulos)

    @cantidad_capitulos = cantidad_capitulos
    super(titulo, anio_de_estreno, genero, fecha_agregado, id)
  end

  def es_el_cantidad_de_capitulos_valido?(cantidad_capitulos)
    !cantidad_capitulos.nil? && cantidad_capitulos >= 0
  end

  def titulo_de_serie
    @titulo.split(' - ')[0]
  end
end

class ErrorAlInstanciarCantidadDeCapitulosInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: anio invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
