require_relative 'pelicula'
require_relative 'fabrica_de_contenido'

class FabricaDeContenido
  TIPO_SERIE = 'serie'.freeze
  TIPO_PELICULA = 'pelicula'.freeze

  def self.crear_contenido(titulo, anio_de_estreno, genero, tipo, fecha_agregado = Date.today, cantidad_capitulos = nil, id = nil)
    if tipo == TIPO_PELICULA
      Pelicula.new(titulo, anio_de_estreno, genero, fecha_agregado, id)
    elsif tipo == TIPO_SERIE
      TemporadaDeSerie.new(titulo, anio_de_estreno, genero, cantidad_capitulos, fecha_agregado, id)
    else
      raise ErrorAlInstanciarTipoInvalido
    end
  end

  def crear_tipo_de_contenido(contenido)
    if contenido.is_a?(TemporadaDeSerie)
      TIPO_SERIE
    elsif contenido.is_a?(Pelicula)
      TIPO_PELICULA
    else
      raise ErrorAlInstanciarTipoInvalido
    end
  end
end

class ErrorAlInstanciarTipoInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: tipo invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
