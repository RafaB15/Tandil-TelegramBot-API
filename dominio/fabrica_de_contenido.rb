require_relative 'pelicula'
require_relative 'fabrica_de_contenido'

class FabricaDeContenido
  def self.crear_contenido(titulo, anio_de_estreno, genero, tipo, fecha_agregado = Date.today, cantidad_capitulos = nil, id = nil)
    if tipo == 'pelicula'
      Pelicula.new(titulo, anio_de_estreno, genero, fecha_agregado, id)
    elsif tipo == 'serie'
      TemporadaDeSerie.new(titulo, anio_de_estreno, genero, fecha_agregado, cantidad_capitulos, id)
    else
      raise ArgumentError, "Valor inválido para tipo de contenido: #{tipo}"
    end
  end

  def crear_tipo_de_contenido(contenido)
    if contenido.is_a?(TemporadaDeSerie)
      'serie'
    elsif contenido.is_a?(Pelicula)
      'pelicula'
    else
      raise ArgumentError, "Valor inválido para tipo: #{tipo}"
    end
  end
end
