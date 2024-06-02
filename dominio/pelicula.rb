class Pelicula
  attr_reader :created_on, :updated_on, :titulo, :anio, :genero
  attr_accessor :id

  def initialize(titulo, anio, genero, id = nil)
    @titulo = titulo
    @anio = anio
    @genero = genero
    @id = id
  end
end
