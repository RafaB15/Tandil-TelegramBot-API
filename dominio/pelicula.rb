require 'date'

class Pelicula
  attr_reader :created_on, :updated_on, :titulo, :fecha_agregado
  attr_accessor :id

  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, id = nil)
    @titulo = titulo
    @anio_de_estreno = anio_de_estreno
    @genero_de_pelicula = genero
    @fecha_agregado = fecha_agregado.is_a?(Date) ? fecha_agregado : DateTime.parse(fecha_agregado)
    @id = id
  end

  def anio
    @anio_de_estreno.anio
  end

  def genero
    @genero_de_pelicula.genero
  end
end
