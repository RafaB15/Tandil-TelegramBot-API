require_relative '../dominio/favorito'

class CreadorDeFavorito
  def initialize(id_telegram, id_contenido)
    @id_telegram = id_telegram
    @id_contenido = id_contenido
  end

  def crear
    usuario = RepositorioUsuarios.new.find_by_id_telegram(@id_telegram)
    pelicula = RepositorioPeliculas.new.find(@id_contenido)
    favorito = Favorito.new(usuario, pelicula)

    RepositorioFavoritos.new.save(favorito)
    favorito
  rescue StandardError => _e
    raise
  end
end
