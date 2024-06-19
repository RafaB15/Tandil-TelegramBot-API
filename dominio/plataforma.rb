require 'date'

require_relative './detalles_de_contenido/constructor_de_detalles_de_contenido'
require_relative './detalles_de_contenido/detalles_de_contenido'
require_relative './modulos_plataforma/plataforma_usuarios'
require_relative './modulos_plataforma/plataforma_contenidos'
require_relative './modulos_plataforma/plataforma_favoritos'
require_relative './modulos_plataforma/plataforma_calificaciones'
require_relative './modulos_plataforma/plataforma_visualizaciones'

class Plataforma
  include PlataformaUsuarios
  include PlataformaContenidos
  include PlataformaFavoritos
  include PlataformaCalificaciones
  include PlataformaVisualizaciones

  def initialize(id_telegram = nil, id_contenido = nil)
    @id_telegram = id_telegram
    @id_contenido = if id_contenido.nil?
                      nil
                    else
                      id_contenido.to_i
                    end
  end

  private

  def obtener_contenido(repositorio_contenidos)
    repositorio_contenidos.find(@id_contenido)
  rescue NameError
    raise ErrorContenidoInexistente
  end

  def fue_el_contenido_visto_por_el_usuario?(usuario, repositorio_visualizaciones)
    visualizacion = repositorio_visualizaciones.find_by_id_usuario_y_id_contenido(usuario.id, @id_contenido)

    !visualizacion.nil?
  end
end

# Error Contenido
# ==============================================================================

class ErrorContenidoInexistente < StandardError
  MSG_DE_ERROR = 'Error: contenido inexistente'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
