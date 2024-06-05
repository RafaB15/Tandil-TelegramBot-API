class CreadorDeVisualizacion
  def initialize(email, id_pelicula, fecha)
    @email = email
    @id_pelicula = id_pelicula
    @fecha = fecha
  end

  def crear
    fecha = Time.iso8601(@fecha)
    usuario = RepositorioUsuarios.new.find_by_email(@email)
    pelicula = RepositorioPeliculas.new.find(@id_pelicula)

    visualizacion = Visualizacion.new(usuario, pelicula, fecha)

    RepositorioVisualizaciones.new.save(visualizacion)

    visualizacion
  rescue StandardError => _e
    raise
  end
end
