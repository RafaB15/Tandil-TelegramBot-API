module PlataformaContenidos
  def registrar_contenido(titulo, anio, genero, repositorio_contenidos, tipo, fecha_agregado = Date.today, cantidad_capitulos = nil)
    genero_de_contenido = Genero.new(genero)
    contenido = FabricaDeContenido.crear_contenido(titulo, anio, genero_de_contenido, tipo, fecha_agregado, cantidad_capitulos)
    contenido.contenido_existente?(repositorio_contenidos)

    repositorio_contenidos.save(contenido)

    contenido
  end

  def obtener_contenido_por_titulo(titulo, repositorio_contenidos)
    repositorio_contenidos.find_by_title(titulo)
  end

  def obtener_contenido_ultimos_agregados(repositorio_contenidos)
    contenidos = repositorio_contenidos.agregados_despues_de_fecha(Date.today - 7)
    contenidos.sort_by { |contenido| [-contenido.fecha_agregado.to_time.to_i, contenido.titulo] }.first(5)
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
