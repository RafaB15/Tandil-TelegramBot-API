module PlataformaFavoritos
  def registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)
    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    contenido = repositorio_contenidos.find(@id_contenido)

    favorito = Favorito.new(usuario, contenido)

    repositorio_favoritos.save(favorito)

    favorito
  end
end
