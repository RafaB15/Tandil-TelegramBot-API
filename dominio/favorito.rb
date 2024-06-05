class Favorito
  attr_accessor :id, :usuario, :contenido
  attr_reader :created_on, :updated_on

  def initialize(usuario, contenido, id = nil)
    @usuario = usuario
    @contenido = contenido
    @id = id
  end
end
