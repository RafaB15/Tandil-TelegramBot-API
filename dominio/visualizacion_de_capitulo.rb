class VisualizacionDeCapitulo
  attr_reader :created_on, :updated_on, :usuario, :temporada_de_serie, :fecha, :numero_capitulo
  attr_accessor :id

  def initialize(usuario, temporada_de_serie, fecha, numero_capitulo, id = nil)
    @usuario = usuario
    @temporada_de_serie = temporada_de_serie
    @fecha = fecha
    @numero_capitulo = numero_capitulo
    @id = id
  end
end

class ErrorTemporadaSinSuficientesCapitulosVistos < ArgumentError
  MSG_DE_ERROR = 'Error: no se vieron suficientes capitulos distintos para contar la temporada como vista'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
