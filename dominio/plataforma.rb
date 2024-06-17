require 'date'

class Plataforma
  def initialize(id_telegram = nil, id_contenido = nil)
    @id_telegram = id_telegram
    @id_contenido = id_contenido
  end

  def registrar_usuario(email, id_telegram, repositorio_usuarios)
    usuario = Usuario.new(email, id_telegram)
    usuario.usuario_existente?(repositorio_usuarios)
    repositorio_usuarios.save(usuario)
    usuario
  end

  def registrar_contenido(titulo, anio, genero, repositorio_contenidos, fecha_agregado = Date.today, cantidad_capitulos = nil)
    genero_de_contenido = Genero.new(genero)
    contenido = FabricaDeContenido.crear_contenido(titulo, anio, genero_de_contenido, fecha_agregado, cantidad_capitulos)
    contenido.contenido_existente?(repositorio_contenidos)
    repositorio_contenidos.save(contenido)

    contenido
  end

  def registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)
    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    pelicula = repositorio_contenidos.find(@id_contenido)
    favorito = Favorito.new(usuario, pelicula)

    repositorio_favoritos.save(favorito)

    favorito
  end

  def registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
    begin
      contenido = repositorio_contenidos.find(@id_contenido)
    rescue NameError
      raise ErrorPeliculaInexistente
    end

    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    el_contenido_fue_visto?(usuario, repositorio_visualizaciones)

    calificacion = repositorio_calificaciones.find_by_id_usuario_y_id_contenido(usuario.id, @id_contenido.to_i)
    puntaje_anterior = nil
    if calificacion.nil?
      calificacion = Calificacion.new(usuario, contenido, puntaje)
    else
      puntaje_anterior = calificacion.recalificar(puntaje)
    end
    repositorio_calificaciones.save(calificacion)
    [calificacion, puntaje_anterior]
  end

  def el_contenido_fue_visto?(usuario, repositorio_visualizaciones)
    visualizacion = repositorio_visualizaciones.find_by_id_usuario_y_id_contenido(usuario.id, @id_contenido.to_i)
    raise ErrorVisualizacionInexistente if visualizacion.nil?
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
    end

    visualizacion
  end

  def obtener_contenido_por_titulo(titulo, repositorio_contenidos)
    contenidos = repositorio_contenidos.find_by_title(titulo)
    raise ErrorPeliculaInexistente if contenidos.empty?

    contenidos
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
    begin
      pelicula = repositorio_contenidos.find(@id_contenido)
    rescue NameError
      raise ErrorPeliculaInexistente
    end

    respuesta = api_detalles_conector.detallar_pelicula(pelicula.titulo)

    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    fue_visto = nil

    fue_visto = !repositorio_visualizaciones.find_by_id_usuario_y_id_contenido(usuario.id, pelicula.id).nil? if usuario

    [respuesta, fue_visto]
  end
end
