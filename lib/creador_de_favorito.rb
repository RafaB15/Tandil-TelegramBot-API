require_relative '../dominio/favorito'

class CreadorDefavorito
  def initialize(email, id_contenido)
    @email = email
    @id_contenido = id_contenido
  end

  def crear
    usuario = RepositorioUsuarios.new.find_by_email(@email)
    pelicula = RepositorioPeliculas.new.find(@id_contenido)
    favorito = Favorito.new(usuario, pelicula)

    RepositorioFavoritos.new.save(favorito)
    favorito
  rescue StandardError => _e
    raise
  end
end
