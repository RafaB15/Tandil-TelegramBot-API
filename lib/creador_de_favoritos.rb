require_relative '../dominio/favorito'

class CreadorDeFavoritos
  def initialize(mail_usuario, id_contenido)
    @mail_usuario = mail_usuario
    @id_contenido = id_contenido
  end

  def crear
    usuario = RepositorioUsuarios.new.find_by_email(@mail_usuario)
    pelicula = RepositorioPeliculas.new.find(@id_contenido)
    favorito = Favorito.new(usuario, pelicula)

    RepositorioFavoritos.new.save(favorito)
    favorito
  rescue StandardError => _e
    raise
  end
end
