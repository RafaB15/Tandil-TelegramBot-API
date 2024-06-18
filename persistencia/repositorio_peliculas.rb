require_relative './repositorio_contenidos'
require 'date'

class RepositorioPeliculas < RepositorioContenidos
  self.model_class = 'Pelicula'
  self.table_name = :contenidos

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
    load_collection dataset.where(Sequel.lit('contenidos.fecha_agregado >= ?', fecha_limite))
  end

  protected

  # def load_object(a_hash)
  #   genero_de_pelicula = Genero.new(a_hash[:genero])
  #   fecha_agregado = a_hash[:fecha_agregado]
  #   Pelicula.new(a_hash[:titulo], a_hash[:anio], genero_de_pelicula, 'pelicula', fecha_agregado, a_hash[:id])
  # end

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
