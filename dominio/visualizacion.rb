class Visualizacion
  attr_reader :created_on, :updated_on, :id_usuario, :id_pelicula, :fecha
  attr_accessor :id

  def initialize(id_usuario, id_pelicula, fecha, id = nil)
    @id_usuario = id_usuario
    @id_pelicula = id_pelicula
    @fecha = fecha
    @id = id
  end
end
