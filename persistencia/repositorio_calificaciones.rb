require_relative './abstract_repository'

class RepositorioCalificaciones < AbstractRepository
  self.table_name = :calificaciones
  self.model_class = 'Calificacion'

  protected

  def load_object(a_hash)
    usuario = RepositorioUsuarios.new.find(a_hash[:id_usuario])
    pelicula = RepositorioPeliculas.new.find(a_hash[:id_pelicula])

    Calificacion.new(usuario, pelicula, a_hash[:calificacion], a_hash[:id])
  end

  def changeset(calificacion)
    {
      id_usuario: calificacion.usuario.id,
      id_pelicula: calificacion.pelicula.id,
      calificacion: calificacion.calificacion
    }
  end
end
