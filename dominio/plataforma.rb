class Plataforma
  def initialize(id_telegram = nil, id_contenido = nil)
    @id_telegram = id_telegram
    @id_contenido = id_contenido
  end

  def registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)
    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    pelicula = repositorio_contenidos.find(@id_contenido)
    favorito = Favorito.new(usuario, pelicula)

    repositorio_favoritos.save(favorito)

    favorito
  end
end
