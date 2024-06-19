class OMDbConectorAPIProxy
  def initialize(logger = nil)
    @omdb_conector_api = ENV['APP_MODE'] == 'test' ? OMDbConectorAPIDouble.new(logger) : OMDbConectorAPI.new(logger)
  end

  def detallar_contenido(titulo)
    @omdb_conector_api.detallar_contenido(titulo)
  end
end
