require_relative 'contenido'

class Pelicula < Contenido
  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, id = nil)
    super(titulo, anio_de_estreno, genero, fecha_agregado, id)
  end
end
