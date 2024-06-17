require_relative './abstract_repository'

class RepositorioCalificaciones < AbstractRepository
  self.table_name = :calificaciones
  self.model_class = 'Calificacion'

  def find_by_id_usuario_y_id_contenido(id_usuario, id_pelicula)
    row = dataset.first(id_usuario:, id_pelicula:)
    load_object(row) unless row.nil?
  end

  protected

  def load_object(a_hash)
    usuario = RepositorioUsuarios.new.find(a_hash[:id_usuario])
    pelicula = RepositorioContenidos.new.find(a_hash[:id_pelicula])

    Calificacion.new(usuario, pelicula, a_hash[:puntaje], a_hash[:id])
  end

  def changeset(calificacion)
    {
      id_usuario: calificacion.usuario.id,
      id_pelicula: calificacion.pelicula.id,
      puntaje: calificacion.puntaje
    }
  end
end
