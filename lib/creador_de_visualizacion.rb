class CreadorDeVisualizacion
  def initialize(id_usuario, id_pelicula, fecha)
    @id_usuario = id_usuario.to_i
    @id_pelicula = id_pelicula.to_i
    @fecha = Time.iso8601(fecha)
  end

  def crear
    usuario = RepositorioUsuarios.new.find(@id_usuario)
    pelicula = RepositorioPeliculas.new.find(@id_pelicula)
    visualizacion = Visualizacion.new(usuario, pelicula, @fecha)
    RepositorioVisualizaciones.new.save(visualizacion)

    visualizacion
  rescue StandardError => _e
    raise
  end
end
