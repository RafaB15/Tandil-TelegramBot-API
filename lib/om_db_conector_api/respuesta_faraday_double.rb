class RespuestaFaradayDouble
  attr_reader :status, :body

  def initialize(estado, cuerpo)
    @status = estado
    @body = cuerpo
  end
end
