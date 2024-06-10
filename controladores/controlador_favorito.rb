class ControladorFavorito < ControladorBase
  def aniadir_favorito(creador_de_favorito)
    favorito = creador_de_favorito.crear
    generar_respuesta(201, { id: favorito.id, id_telegram: favorito.usuario.id_telegram, id_contenido: favorito.contenido.id })
  rescue StandardError => e
    ManejadorDeErrores.new.manejar_error(e)
  end
end
