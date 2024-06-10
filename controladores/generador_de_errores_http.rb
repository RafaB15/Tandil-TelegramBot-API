require 'sinatra'

class GeneradorDeErroresHTTP
  attr_reader :respuesta, :estado

  ERROR_MAP = {
    400 => :generar_respuesta400,
    409 => :generar_respuesta409,
    422 => :generar_respuesta422,
    500 => :generar_respuesta_default
  }.freeze

  def initialize(estado = 500, campo = '', mensaje = '')
    @estado = estado
    @campo = campo
    @mensaje = mensaje
    @respuesta = generar_respuesta
  end

  def generar_respuesta_final(error, mensaje, detalles = {})
    settings.logger.info "GENERAR RESPUESTA FINAL : #{mensaje}"

    {
      error:,
      message: mensaje,
      details: detalles
    }.to_json
  end

  def generar_respuesta
    if ERROR_MAP.key?(@estado)
      send(ERROR_MAP[@estado])
    else
      generar_respuesta_default
    end
  end

  private

  def generar_respuesta400
    error = 'Solicitud Incorrecta'
    mensaje = "El parametro requerido #{@campo} debe ser #{@mensaje}"
    detalles = { field: @campo }
    generar_respuesta_final(error, mensaje, detalles)
  end

  def generar_respuesta409
    error = 'Conflicto'
    mensaje = @mensaje
    detalles = { field: @campo }
    generar_respuesta_final(error, mensaje, detalles)
  end

  def generar_respuesta422
    error = 'Entidad no procesable'
    mensaje = "La solicitud no pudo completarse debido a un error semántico en #{@campo}"
    detalles = { field: @campo }
    generar_respuesta_final(error, mensaje, detalles)
  end

  def generar_respuesta_default
    error = 'Error Interno del Servidor'
    mensaje = 'Ocurrió un error inesperado en el servidor. Por favor, inténtelo de nuevo más tarde.'
    detalles = { field: @mensaje }
    generar_respuesta_final(error, mensaje, detalles)
  end
end
