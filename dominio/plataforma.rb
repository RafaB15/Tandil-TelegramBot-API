require 'date'

require_relative './detalles_de_contenido/constructor_de_detalles_de_contenido'
require_relative './detalles_de_contenido/detalles_de_contenido'

class Plataforma # rubocop:disable Metrics/ClassLength
  def initialize(id_telegram = nil, id_contenido = nil)
    @id_telegram = id_telegram
    @id_contenido = if id_contenido.nil?
                      nil
                    else
                      id_contenido.to_i
                    end
  end

  def registrar_usuario(email, id_telegram, repositorio_usuarios)
    usuario = Usuario.new(email, id_telegram)
    usuario.usuario_existente?(repositorio_usuarios)
    repositorio_usuarios.save(usuario)
    usuario
  end

  def registrar_contenido(titulo, anio, genero, repositorio_contenidos, tipo, fecha_agregado = Date.today, cantidad_capitulos = nil)
    genero_de_contenido = Genero.new(genero)
    contenido = FabricaDeContenido.crear_contenido(titulo, anio, genero_de_contenido, tipo, fecha_agregado, cantidad_capitulos)
    contenido.contenido_existente?(repositorio_contenidos)

    repositorio_contenidos.save(contenido)

    contenido
  end

  def registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)
    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    contenido = repositorio_contenidos.find(@id_contenido)

    favorito = Favorito.new(usuario, contenido)

    repositorio_favoritos.save(favorito)

    favorito
  end

  def registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones, repositorio_visualizaciones_de_capitulos = nil)
    contenido = obtener_contenido(repositorio_contenidos)

    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)

    unless fue_el_contenido_visto_por_el_usuario?(usuario, repositorio_visualizaciones)
      raise ErrorTemporadaSinSuficientesCapitulosVistos unless tiene_suficientes_capitulos_vistos?(contenido, repositorio_visualizaciones_de_capitulos)

      raise ErrorVisualizacionInexistente
    end

    calificacion = repositorio_calificaciones.find_by_id_usuario_y_id_contenido(usuario.id, @id_contenido)
    puntaje_anterior = nil
    if calificacion.nil?
      calificacion = Calificacion.new(usuario, contenido, puntaje)
    else
      puntaje_anterior = calificacion.recalificar(puntaje)
    end
    repositorio_calificaciones.save(calificacion)
    [calificacion, puntaje_anterior]
  end

  def registrar_visualizacion(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, repositorio_visualizaciones_de_capitulos, numero_capitulo, email, fecha)
    contenido = repositorio_contenidos.find(@id_contenido)
    usuario = repositorio_usuarios.find_by_email(email)
    fecha_time = Time.iso8601(fecha)
    if numero_capitulo.nil?
      visualizacion = Visualizacion.new(usuario, contenido, fecha_time)
      repositorio_visualizaciones.save(visualizacion)
    else
      visualizacion = VisualizacionDeCapitulo.new(usuario, contenido, fecha_time, numero_capitulo)
      repositorio_visualizaciones_de_capitulos.save(visualizacion)
      if repositorio_visualizaciones_de_capitulos.count_visualizaciones_de_capitulos_por_usuario(usuario.id, contenido.id) == 4
        repositorio_visualizaciones.save(Visualizacion.new(usuario, contenido, fecha_time))
      end
    end
    visualizacion
  end

  def obtener_contenido_por_titulo(titulo, repositorio_contenidos)
    repositorio_contenidos.find_by_title(titulo)
  end

  def obtener_contenido_ultimos_agregados(repositorio_contenidos)
    contenidos = repositorio_contenidos.agregados_despues_de_fecha(Date.today - 7)
    contenidos.sort_by { |contenido| [-contenido.fecha_agregado.to_time.to_i, contenido.titulo] }.first(5)
  end

  def obtener_visualizacion_mas_vistos(repositorio_visualizaciones)
    visualizaciones = repositorio_visualizaciones.all
    ContadorDeVisualizaciones.new(visualizaciones).obtener_mas_vistos
  end

  def obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, api_detalles_conector)
    contenido = obtener_contenido(repositorio_contenidos)
    constructor_de_detalles_de_contenido = ConstructorDeDetallesDeContenido.new
    constructor_de_detalles_de_contenido.definir_contenido(contenido)

    titulo = constructor_de_detalles_de_contenido.construir.titulo
    detalles_omdb = detallar_contenido_via_api(api_detalles_conector, titulo)

    constructor_de_detalles_de_contenido.definir_detalles(detalles_omdb['Awards'], detalles_omdb['Director'], detalles_omdb['Plot'])

    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    if usuario
      fue_visto = fue_el_contenido_visto_por_el_usuario?(usuario, repositorio_visualizaciones)
      constructor_de_detalles_de_contenido.definir_fue_visto(fue_visto)
    end

    constructor_de_detalles_de_contenido.construir
  end

  private

  def obtener_contenido(repositorio_contenidos)
    repositorio_contenidos.find(@id_contenido)
  rescue NameError
    raise ErrorContenidoInexistente
  end

  def detallar_contenido_via_api(api_detalles_conector, titulo)
    omdb_respuesta = api_detalles_conector.detallar_contenido(titulo)

    raise ErrorInesperadoEnLaAPIDeOMDb if omdb_respuesta.status != 200

    detalles_contenido = JSON.parse(omdb_respuesta.body)

    raise ErrorContenidoInexistenteEnLaAPIDeOMDb if detalles_contenido['Response'] == 'False'

    detalles_contenido.each do |campo_detalle, valor_detalle|
      detalles_contenido[campo_detalle] = valor_detalle == 'N/A' ? nil : valor_detalle
    end

    detalles_contenido
  end

  def fue_el_contenido_visto_por_el_usuario?(usuario, repositorio_visualizaciones)
    visualizacion = repositorio_visualizaciones.find_by_id_usuario_y_id_contenido(usuario.id, @id_contenido)

    !visualizacion.nil?
  end

  CANTIDAD_DE_CAPITULOS_MINIMOS_PARA_CONSIDERAR_TEMPORADA_VISTA = 4
  def tiene_suficientes_capitulos_vistos?(contenido, repositorio_visualizaciones_de_capitulos)
    return true if repositorio_visualizaciones_de_capitulos.nil?

    conteo_visualizacion = repositorio_visualizaciones_de_capitulos.count_visualizaciones_de_capitulos_por_usuario(contenido.id, @id_telegram)

    contenido.is_a?(TemporadaDeSerie) && conteo_visualizacion > CANTIDAD_DE_CAPITULOS_MINIMOS_PARA_CONSIDERAR_TEMPORADA_VISTA
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

# Error detallar contenido
# ==============================================================================

class ErrorContenidoInexistenteEnLaAPIDeOMDb < StandardError
  MSG_DE_ERROR = 'Error: El contenido no existe en la API de OMDb o no hay detalles para mostrar'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorInesperadoEnLaAPIDeOMDb < StandardError
  MSG_DE_ERROR = 'Error: Algo fallo en la API de OMDb'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end
