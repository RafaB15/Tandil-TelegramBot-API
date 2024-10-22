require_relative './abstract_repository'

class RepositorioVisualizaciones < AbstractRepository
  self.table_name = :visualizaciones
  self.model_class = 'Visualizacion'

  def find_by_id_usuario_y_id_contenido(id_usuario, id_contenido)
    row = dataset.first(id_usuario:, id_contenido:)
    load_object(row) unless row.nil?
  end

  protected

  def load_object(a_hash)
    usuario = RepositorioUsuarios.new.find(a_hash[:id_usuario])
    contenido = RepositorioContenidos.new.find(a_hash[:id_contenido])

    Visualizacion.new(usuario, contenido, a_hash[:fecha], a_hash[:id])
  end

  def changeset(visualizacion)
    {
      id_usuario: visualizacion.usuario.id,
      id_contenido: visualizacion.contenido.id,
      fecha: visualizacion.fecha
    }
  end
end
