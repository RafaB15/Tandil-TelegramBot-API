class Favorito
  attr_reader :created_on, :updated_on, :usuario, :contenido
  attr_accessor :id

  def initialize(usuario, contenido, id = nil)
    @usuario = usuario
    @contenido = contenido
    @id = id
  end
end
