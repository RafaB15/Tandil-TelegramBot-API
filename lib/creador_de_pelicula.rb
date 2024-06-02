require_relative '../dominio/pelicula'

class CreadorDePelicula
  def initialize(titulo, anio, genero)
    @titulo = titulo
    @anio = anio
    @genero = genero
  end

  def crear
    pelicula = Pelicula.new(@titulo, @anio, @genero)
    RepositorioPeliculas.new.save(pelicula)

    pelicula
  end
end
