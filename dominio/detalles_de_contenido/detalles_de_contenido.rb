require_relative '../contenido'

class DetallesDeContenido
  attr_reader :premios, :director, :sinopsis, :fue_visto

  def initialize(contenido, premios, director, sinopsis)
    @contenido = contenido
    @premios = premios
    @director = director
    @sinopsis = sinopsis
    @fue_visto = nil
  end

  def actualizar_fue_visto(fue_visto)
    @fue_visto = fue_visto
  end

  def titulo
    if @contenido.is_a?(Pelicula)
      @contenido.titulo
    elsif @contenido.is_a?(TemporadaDeSerie)
      @contenido.titulo_de_serie
    end
  end

  def anio
    @contenido.anio
  end
end
