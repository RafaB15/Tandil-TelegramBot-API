require_relative './repositorio_contenidos'
require 'date'

class RepositorioTemporadasDeSeries < RepositorioContenidos
  self.table_name = :contenidos
  self.model_class = 'TemporadaDeSerie'

  protected

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
