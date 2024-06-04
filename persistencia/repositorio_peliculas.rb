require_relative './abstract_repository'

class RepositorioPeliculas < AbstractRepository
  self.table_name = :peliculas
  self.model_class = 'Pelicula'

  protected

  def load_object(a_hash)
    anio_de_estreno = AnioDeEstreno.new(a_hash[:anio])
    Pelicula.new(a_hash[:titulo], anio_de_estreno, a_hash[:genero], a_hash[:id])
  end

  def changeset(pelicula)
    {
      titulo: pelicula.titulo,
      anio: pelicula.anio,
      genero: pelicula.genero
    }
  end
end
