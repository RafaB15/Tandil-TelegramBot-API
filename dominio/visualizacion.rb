class Visualizacion
  attr_reader :created_on, :updated_on, :usuario, :pelicula, :fecha
  attr_accessor :id

  def initialize(usuario, pelicula, fecha, id = nil)
    @usuario = usuario
    @pelicula = pelicula
    @fecha = fecha
    @id = id
  end
end

class ErrorVisualizacionInexistente < StandardError
  MSG_DE_ERROR = 'Error: visualizacion inexistente'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
