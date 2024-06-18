require_relative './repositorio_contenidos'
require 'date'

class RepositorioTemporadasDeSeries < RepositorioContenidos
  self.model_class = 'Serie'
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
  #   genero_de_temporada_de_serie = Genero.new(a_hash[:genero])
  #   fecha_agregado = a_hash[:fecha_agregado]
  #   Serie.new(a_hash[:titulo], a_hash[:anio], genero_de_temporada_de_serie, 'serie', fecha_agregado, a_hash[:cantidad_capitulos] ,a_hash[:id])
  # end

  def changeset(temporada_de_serie)
    {
      titulo: temporada_de_serie.titulo,
      anio: temporada_de_serie.anio,
      genero: temporada_de_serie.genero,
      tipo: 'serie',
      fecha_agregado: temporada_de_serie.fecha_agregado,
      cantidad_capitulos: temporada_de_serie.cantidad_capitulos
    }
  end
end
