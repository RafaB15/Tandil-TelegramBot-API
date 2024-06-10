class ControladorVersion < ControladorBase
  def enviar_version(version)
    generar_respuesta(200, { version: })
  end
end
