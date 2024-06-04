class ErrorAlInstanciarPeliculaAnioInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: anio invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class AnioDeEstreno
  attr_reader :anio

  def initialize(anio)
    raise ErrorAlInstanciarPeliculaAnioInvalido unless es_el_telegram_id_valido?(anio)

    @anio = anio
  end

  private

  def es_el_telegram_id_valido?(anio)
    !anio.nil? && anio >= 0
  end
end
