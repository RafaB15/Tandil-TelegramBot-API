require_relative 'pelicula'
require_relative 'serie'

class FabricaDeContenido
  def self.crear_contenido(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, cantidad_capitulos = nil, id = nil)
    if cantidad_capitulos.nil? || cantidad_capitulos < 1
      Pelicula.new(titulo, anio_de_estreno, genero, fecha_agregado, cantidad_capitulos, id)
    elsif cantidad_capitulos >= 1
      Serie.new(titulo, anio_de_estreno, genero, fecha_agregado, cantidad_capitulos, id)
    else
      raise ArgumentError, "Valor inválido para cantidad_capitulos: #{cantidad_capitulos}"
    end
  end
end
