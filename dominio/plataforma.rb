require 'date'

class Plataforma
  def initialize(id_telegram = nil, id_contenido = nil)
    @id_telegram = id_telegram
    @id_contenido = id_contenido
  end

  def registrar_usuario(email, id_telegram, repositorio_usuarios)
    usuario = Usuario.new(email, id_telegram)
    repositorio_usuarios.save(usuario)
    usuario
  end

  def registrar_contenido(titulo, anio, genero, repositorio_contenidos, fecha_agregado = Date.today)
    genero_de_pelicula = Genero.new(genero)
    pelicula = Pelicula.new(titulo, anio, genero_de_pelicula, fecha_agregado)

    repositorio_contenidos.save(pelicula)

    pelicula
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

    visualizacion = repositorio_visualizaciones.find_by_id_usuario_y_id_contenido(usuario.id, @id_contenido.to_i)

    raise ErrorVisualizacionInexistente if visualizacion.nil?

    calificacion = Calificacion.new(usuario, contenido, puntaje)

    calificacion.es_una_recalificacion?(repositorio_calificaciones)

    repositorio_calificaciones.save(calificacion)
    calificacion
  end

  def registrar_visualizacion(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, email, fecha)
    contenido = repositorio_contenidos.find(@id_contenido)
    usuario = repositorio_usuarios.find_by_email(email)
    fecha_time = Time.iso8601(fecha)
    visualizacion = Visualizacion.new(usuario, contenido, fecha_time)

    repositorio_visualizaciones.save(visualizacion)

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
end
