require_relative './repositorio_contenidos'
require 'date'

class RepositorioPeliculas < RepositorioContenidos
  self.table_name = :contenidos
  self.model_class = 'Pelicula'

  protected

  def changeset(pelicula)
    {
      titulo: pelicula.titulo,
      anio: pelicula.anio,
      genero: pelicula.genero,
      tipo: 'pelicula',
      fecha_agregado: pelicula.fecha_agregado,
      cantidad_capitulos: nil
    }
  end
end
