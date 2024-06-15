class ContadorDeVisualizaciones
  def initialize(visualizaciones)
    @visualizaciones = visualizaciones
  end

  def obtener_mas_vistos
    mas_vistos_nombre = conseguir_mas_vistos_por_nombre
    mas_vistos_nombre.sort_by { |contenido| [-contenido[:vistas], contenido[:pelicula][:titulo]] }.first(3)
  end

  private

  def conseguir_mas_vistos_por_nombre
    mas_vistos = contar_vistas_por_id(@visualizaciones)
    nombres = nombres_por_id(@visualizaciones)

    mas_vistos.map do |id_pelicula, count|
      {
        id: id_pelicula,
        pelicula: {
          titulo: nombres[id_pelicula].titulo,
          anio: nombres[id_pelicula].anio,
          genero: nombres[id_pelicula].genero

        },
        vistas: count
      }
    end
  end

  def contar_vistas_por_id(visualizaciones)
    visualizaciones.each_with_object(Hash.new(0)) do |visualizacion, mas_vistos|
      mas_vistos[visualizacion.pelicula.id] += 1
    end
  end

  def nombres_por_id(visualizaciones)
    visualizaciones.each_with_object({}) do |visualizacion, nombres|
      nombres[visualizacion.pelicula.id] = visualizacion.pelicula
    end
  end
end
