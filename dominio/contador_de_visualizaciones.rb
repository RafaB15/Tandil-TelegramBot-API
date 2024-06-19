class ContadorDeVisualizaciones
  def initialize(visualizaciones)
    @visualizaciones = visualizaciones
  end

  def obtener_mas_vistos
    mas_vistos_nombre = conseguir_mas_vistos_por_nombre
    mas_vistos_nombre.sort_by { |contenido| [-contenido[:vistas], contenido[:contenido][:titulo]] }.first(3)
  end

  private

  def conseguir_mas_vistos_por_nombre
    mas_vistos = contar_vistas_por_id(@visualizaciones)
    nombres = nombres_por_id(@visualizaciones)

    mas_vistos.map do |id_contenido, count|
      {
        id: id_contenido,
        contenido: {
          titulo: nombres[id_contenido].titulo,
          anio: nombres[id_contenido].anio,
          genero: nombres[id_contenido].genero

        },
        vistas: count
      }
    end
  end

  def contar_vistas_por_id(visualizaciones)
    visualizaciones.each_with_object(Hash.new(0)) do |visualizacion, mas_vistos|
      mas_vistos[visualizacion.contenido.id] += 1
    end
  end

  def nombres_por_id(visualizaciones)
    visualizaciones.each_with_object({}) do |visualizacion, nombres|
      nombres[visualizacion.contenido.id] = visualizacion.contenido
    end
  end
end
