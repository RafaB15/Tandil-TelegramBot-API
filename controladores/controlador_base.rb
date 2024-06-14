require 'sinatra'
require 'json'

class ControladorBase
  attr_reader :estado, :respuesta

  def initialize
    @estado = 0
    @respuesta = nil
  end

  def generar_respuesta(estado, data)
    @estado = estado
    @respuesta = data.to_json
  end

  def generar_respuesta_error(mapeo_error_http)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    @estado = error_response.estado
    @respuesta = error_response.respuesta
  end
end
