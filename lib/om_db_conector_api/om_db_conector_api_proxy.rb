class OMDbConectorAPIProxy
  def initialize
    @omdb_conector_api = ENV['APP_MODE'] == 'test' ? OMDbConectorAPIDouble.new : OMDbConectorAPI.new
  end

  def detallar_pelicula(titulo, logger = nil)
    @omdb_conector_api.detallar_pelicula(titulo, logger)
  end
end
