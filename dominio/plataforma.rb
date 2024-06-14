class Plataforma
  def initialize(id_telegram = nil, id_contenido = nil)
    @id_telegram = id_telegram
    @id_contenido = id_contenido
  end

  def registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)
    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)
    pelicula = repositorio_contenidos.find(@id_contenido)
    favorito = Favorito.new(usuario, pelicula)

    repositorio_favoritos.save(favorito)

    favorito
  end

  def registrar_calificacion(numero_calificacion, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
    begin
      contenido = repositorio_contenidos.find(@id_contenido)
    rescue NameError
      raise ErrorPeliculaInexistente
    end

    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)

    visualizacion = repositorio_visualizaciones.find_by_usuario_y_contenido(usuario.id, @id_contenido.to_i)

    raise ErrorVisualizacionInexistente if visualizacion.nil?

    calificacion = Calificacion.new(usuario, contenido, numero_calificacion)
    repositorio_calificaciones.save(calificacion)
    calificacion
  end
end