require_relative 'contenido'

class Serie < Contenido
  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, cantidad_capitulos = 1, id = nil)
    @cantidad_capitulos = cantidad_capitulos
    super(titulo, anio_de_estreno, genero, fecha_agregado, id)
  end
end
