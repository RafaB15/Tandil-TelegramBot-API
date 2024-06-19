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
