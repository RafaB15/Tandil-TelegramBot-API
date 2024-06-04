class Pelicula
  attr_reader :created_on, :updated_on, :titulo, :genero
  attr_accessor :id

  def initialize(titulo, anio_de_estreno, genero, id = nil)
    @titulo = titulo
    @anio_de_estreno = anio_de_estreno
    @genero = genero
    @id = id
  end

  def anio
    @anio_de_estreno.anio
  end
end
