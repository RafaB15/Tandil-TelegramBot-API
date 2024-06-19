class Visualizacion
  attr_reader :created_on, :updated_on, :usuario, :contenido, :fecha
  attr_accessor :id

  def initialize(usuario, contenido, fecha, id = nil)
    @usuario = usuario
    @contenido = contenido
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
