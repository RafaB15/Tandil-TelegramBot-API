require_relative './abstract_repository'

class RepositorioFavoritos < AbstractRepository
  self.table_name = :favoritos
  self.model_class = 'Favorito'

  def find_by_user(id_usuario)
    load_collection dataset.where(id_usuario:)
  end

  protected

  def load_object(a_hash)
    usuario = RepositorioUsuarios.new.find(a_hash[:id_usuario])
    pelicula = RepositorioPeliculas.new.find(a_hash[:id_pelicula])

    Favorito.new(usuario, pelicula)
  end

  def changeset(favorito)
    {
      id_usuario: favorito.usuario.id,
      id_pelicula: favorito.contenido.id
    }
  end
end
