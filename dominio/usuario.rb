class Usuario
  attr_reader :nombre, :updated_on, :created_on
  attr_accessor :id

  def initialize(nombre, id = nil)
    @nombre = nombre
    @id = id
  end
end
