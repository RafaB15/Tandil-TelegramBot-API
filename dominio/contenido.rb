require 'date'

class Contenido
  attr_reader :created_on, :updated_on, :titulo, :fecha_agregado, :anio
  attr_accessor :id

  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, id = nil)
    raise ErrorAlInstanciarTituloInvalido unless es_el_titulo_valido?(titulo)
    raise ErrorAlInstanciarAnioInvalido unless es_el_anio_valido?(anio_de_estreno)
    raise ErrorAlInstanciarAnioInvalido unless es_el_anio_valido?(anio_de_estreno)

    @titulo = titulo
    @anio = anio_de_estreno
    @genero_de_contenido = genero
    @fecha_agregado = fecha_agregado.is_a?(Date) ? fecha_agregado : DateTime.parse(fecha_agregado)
    @id = id
  end

  def genero
    @genero_de_contenido.genero
  end

  def contenido_existente?(repositorio_contenidos)
    raise ErrorAlPersistirContenidoYaExistente if repositorio_contenidos.find_by_titulo_y_anio(@titulo, @anio)
  end

  private

  def es_el_titulo_valido?(titulo)
    !titulo.nil? && !titulo.empty?
  end

  def es_el_anio_valido?(anio)
    !anio.nil? && (anio.is_a?(Integer) || anio.is_a?(Float)) && anio >= 0
  end
end

class ErrorAlInstanciarTituloInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: titulo invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorAlInstanciarAnioInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: anio invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorAlPersistirContenidoYaExistente < StandardError
  MSG_DE_ERROR = 'Error: contenido ya existente'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
