require_relative './abstract_repository'

class RepositorioVisualizaciones < AbstractRepository
  self.table_name = :visualizaciones
  self.model_class = 'Visualizacion'

  protected

  def load_object(a_hash)
    usuario = RepositorioUsuarios.new.find(a_hash[:id_usuario])
    pelicula = RepositorioPeliculas.new.find(a_hash[:id_pelicula])
    Visualizacion.new(usuario, pelicula, a_hash[:fecha], a_hash[:id])
  end

  def changeset(visualizacion)
    {
      id_usuario: visualizacion.usuario.id,
      id_pelicula: visualizacion.pelicula.id,
      fecha: visualizacion.fecha
    }
  end
end
