require_relative 'contenido'

class ErrorPeliculaInexistente < StandardError
  MSG_DE_ERROR = 'Error: pelicula inexistente'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class Pelicula < Contenido
  def initialize(titulo, anio_de_estreno, genero, fecha_agregado = Date.today, id = nil)
    super(titulo, anio_de_estreno, genero, fecha_agregado, id)
  end
end
