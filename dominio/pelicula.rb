class Pelicula
  attr_reader :created_on, :updated_on, :titulo
  attr_accessor :id

  def initialize(titulo, anio_de_estreno, genero, id = nil)
    @titulo = titulo
    @anio_de_estreno = anio_de_estreno
    @genero_de_pelicula = genero
    @id = id
  end

  def anio
    @anio_de_estreno.anio
  end

  def genero
    @genero_de_pelicula.genero
  end
end
