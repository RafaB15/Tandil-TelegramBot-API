require_relative './abstract_repository'

class RepositorioVisualizacionesDeCapitulos < AbstractRepository
  self.table_name = :visualizaciones_de_capitulos
  self.model_class = 'VisualizacionDeCapitulo'

  def find_by_id_usuario_y_id_contenido(id_usuario, id_pelicula)
    row = dataset.first(id_usuario:, id_pelicula:)
    load_object(row) unless row.nil?
  end

  protected

  def load_object(a_hash)
    usuario = RepositorioUsuarios.new.find(a_hash[:id_usuario])
    temporada_de_serie = RepositorioContenidos.new.find(a_hash[:id_contenido])
    VisualizacionDeCapitulo.new(usuario, temporada_de_serie, a_hash[:fecha], a_hash[:numero_capitulo], a_hash[:id])
  end

  def changeset(visualizacion_de_capitulo)
    {
      id_usuario: visualizacion_de_capitulo.usuario.id,
      id_contenido: visualizacion_de_capitulo.temporada_de_serie.id,
      fecha: visualizacion_de_capitulo.fecha
    }
  end
end
