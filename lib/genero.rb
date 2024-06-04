class ErrorAlInstanciarPeliculaGeneroInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: genero invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class Genero
  attr_reader :genero

  GENEROS = %w[comedia drama accion].freeze

  def initialize(genero)
    raise ErrorAlInstanciarPeliculaGeneroInvalido unless es_el_genero_valido?(genero)

    @genero = genero.downcase
  end

  private

  def es_el_genero_valido?(genero)
    GENEROS.include? genero
  end
end
