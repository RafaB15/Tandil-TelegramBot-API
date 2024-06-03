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
