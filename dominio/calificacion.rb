class Calificacion
  attr_reader :created_on, :updated_on, :usuario, :pelicula, :calificacion
  attr_accessor :id

  def initialize(usuario, pelicula, calificacion, id = nil)
    @usuario = usuario
    @pelicula = pelicula
    @calificacion = calificacion
    @id = id
  end
end
