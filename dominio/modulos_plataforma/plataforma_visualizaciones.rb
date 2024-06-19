module PlataformaVisualizaciones
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

  def obtener_visualizacion_mas_vistos(repositorio_visualizaciones)
    visualizaciones = repositorio_visualizaciones.all
    ContadorDeVisualizaciones.new(visualizaciones).obtener_mas_vistos
  end
end
