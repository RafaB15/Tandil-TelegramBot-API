require_relative './controlador_base'

class ControladorUsuarios < ControladorBase
  def reiniciar_usuarios
    @estado = 200
  end

  def enviar_usuarios(usuarios)
    respuesta = usuarios.map { |u| { email: u.email, id_telegram: u.id_telegram, id: u.id } }
    generar_respuesta(200, respuesta)
  end

  def crear_usuario(creador_de_usuario)
    usuario = creador_de_usuario.crear
    generar_respuesta(201, { id: usuario.id, email: usuario.email, id_telegram: usuario.id_telegram })
  rescue StandardError => e
    error_info = ManejadorDeErrores.new.manejar_error(e)
    generar_respuesta_error(error_info[:estado], error_info[:campo], error_info[:mensaje])
  end
end
