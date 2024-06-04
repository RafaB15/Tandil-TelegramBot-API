require_relative './abstract_repository'

class RepositorioPeliculas < AbstractRepository
  self.table_name = :peliculas
  self.model_class = 'Pelicula'

  protected

  def load_object(a_hash)
    genero_de_pelicula = Genero.new(a_hash[:genero])
    anio_de_estreno = AnioDeEstreno.new(a_hash[:anio])
    Pelicula.new(a_hash[:titulo], anio_de_estreno, genero_de_pelicula, a_hash[:id])
  end

  def changeset(pelicula)
    {
      titulo: pelicula.titulo,
      anio: pelicula.anio,
      genero: pelicula.genero
    }
  end
end
