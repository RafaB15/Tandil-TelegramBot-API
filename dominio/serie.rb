require 'date'

class Serie
  attr_reader :created_on, :updated_on, :titulo, :fecha_agregado, :anio, :tipo, :cantidad_capitulos
  attr_accessor :id

  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, cantidad_capitulos = 1, id = nil)
    @titulo = titulo
    @anio = anio_de_estreno
    @genero_de_pelicula = genero
    @fecha_agregado = fecha_agregado.is_a?(Date) ? fecha_agregado : DateTime.parse(fecha_agregado)
    @tipo = tipo
    @cantidad_capitulos = cantidad_capitulos
    @id = id
  end

  def genero
    @genero_de_pelicula.genero
  end
end
