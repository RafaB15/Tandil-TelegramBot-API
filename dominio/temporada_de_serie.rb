require_relative 'contenido'

class TemporadaDeSerie < Contenido
  attr_reader :cantidad_capitulos

  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, cantidad_capitulos = 1, id = nil)
    @cantidad_capitulos = cantidad_capitulos
    super(titulo, anio_de_estreno, genero, fecha_agregado, id)
  end

  def titulo_de_serie
    @titulo.split(' - ')[0]
  end
end
