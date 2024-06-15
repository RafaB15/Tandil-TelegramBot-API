require 'date'

class ErrorAlInstanciarPeliculaTituloInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: titulo invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorPeliculaInexistente < StandardError
  MSG_DE_ERROR = 'Error: pelicula inexistente'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class Pelicula
  attr_reader :created_on, :updated_on, :titulo, :fecha_agregado
  attr_accessor :id

  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, id = nil)
    raise ErrorAlInstanciarPeliculaTituloInvalido unless es_el_titulo_valido?(titulo)

    @titulo = titulo
    @anio_de_estreno = anio_de_estreno
    @genero_de_pelicula = genero
    @fecha_agregado = fecha_agregado.is_a?(Date) ? fecha_agregado : DateTime.parse(fecha_agregado)
    @id = id
  end

  def anio
    @anio_de_estreno.anio
  end

  def genero
    @genero_de_pelicula.genero
  end

  private

  def es_el_titulo_valido?(titulo)
    !titulo.nil? && !titulo.empty?
  end
end
