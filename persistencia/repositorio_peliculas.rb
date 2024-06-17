require_relative './abstract_repository'
require 'date'

class RepositorioPeliculas < AbstractRepository
  self.table_name = :peliculas
  self.model_class = 'Pelicula'

  def find_by_titulo_y_anio(titulo, anio)
    row = dataset.first(titulo:, anio:)
    load_object(row) unless row.nil?
  end

  def find_by_title(titulo)
    load_collection dataset.where(Sequel.like(:titulo, "%#{titulo}%", case_insensitive: true))
  end

  def find_by_id(id)
    load_collection dataset.where(id:)
  end

  def agregados_despues_de_fecha(fecha_limite)
    load_collection dataset.where(Sequel.lit('peliculas.fecha_agregado >= ?', fecha_limite))
  end

  protected

  def load_object(a_hash)
    genero_de_pelicula = Genero.new(a_hash[:genero])
    fecha_agregado = a_hash[:fecha_agregado]
    FabricaDeContenido.crear_contenido(a_hash[:titulo], a_hash[:anio], genero_de_pelicula, fecha_agregado, a_hash[:cantidad_capitulos], a_hash[:id])
  end

  def changeset(pelicula)
    {
      titulo: pelicula.titulo,
      anio: pelicula.anio,
      genero: pelicula.genero,
      fecha_agregado: pelicula.fecha_agregado
    }
  end
end
