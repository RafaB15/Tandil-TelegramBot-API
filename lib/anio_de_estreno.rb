class AnioDeEstreno
  attr_reader :anio

  def initialize(anio)
    @anio = anio > 0 ? anio : raise(ArgumentError, 'Error: anio invalido')
  end
end
