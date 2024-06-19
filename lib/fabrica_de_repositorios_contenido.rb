require_relative '../persistencia/repositorio_peliculas'
require_relative '../persistencia/repositorio_temporadas_de_series'

class FabricaDeRepositoriosContenido
  TIPO_SERIE = 'serie'.freeze
  TIPO_PELICULA = 'pelicula'.freeze

  def self.crear_contenido(tipo = nil)
    if tipo == TIPO_PELICULA
      RepositorioPeliculas.new
    elsif tipo == TIPO_SERIE
      RepositorioTemporadasDeSeries.new
    else
      raise ErrorAlInstanciarTipoInvalido
    end
  end
end
