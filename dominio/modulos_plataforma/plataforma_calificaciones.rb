module PlataformaCalificaciones
  def registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones, repositorio_visualizaciones_de_capitulos = nil)
    contenido = obtener_contenido(repositorio_contenidos)

    usuario = repositorio_usuarios.find_by_id_telegram(@id_telegram)

    unless fue_el_contenido_visto_por_el_usuario?(usuario, repositorio_visualizaciones)
      raise ErrorTemporadaSinSuficientesCapitulosVistos if contenido.is_a?(TemporadaDeSerie) && !tiene_suficientes_capitulos_vistos?(contenido, repositorio_visualizaciones_de_capitulos)

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

  private

  CANTIDAD_DE_CAPITULOS_MINIMOS_PARA_CONSIDERAR_TEMPORADA_VISTA = 4
  def tiene_suficientes_capitulos_vistos?(contenido, repositorio_visualizaciones_de_capitulos)
    return true if repositorio_visualizaciones_de_capitulos.nil?

    conteo_visualizacion = repositorio_visualizaciones_de_capitulos.count_visualizaciones_de_capitulos_por_usuario(contenido.id, @id_telegram)

    conteo_visualizacion > CANTIDAD_DE_CAPITULOS_MINIMOS_PARA_CONSIDERAR_TEMPORADA_VISTA
  end
end
