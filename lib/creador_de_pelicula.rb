require_relative '../dominio/pelicula'

class CreadorDePelicula
  def initialize(titulo, anio, genero)
    @titulo = titulo
    @anio = anio
    @genero = genero
  end

  def crear
    anio_de_estreno = AnioDeEstreno.new(@anio)
    pelicula = Pelicula.new(@titulo, anio_de_estreno, @genero)
    RepositorioPeliculas.new.save(pelicula)

    pelicula
  rescue StandardError => _e
    raise
  end
end
