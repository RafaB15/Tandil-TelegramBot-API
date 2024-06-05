class ContadorDeVistas
  def initialize(visualizaciones)
    @visualizaciones = visualizaciones
  end

  def obtener_mas_vistos
    mas_vistos = contar_vistas_por_id(@visualizaciones)
    nombres = nombres_por_id(@visualizaciones)
    mas_vistos_nombre = mas_vistos.map { |id_pelicula, count| { id: id_pelicula, titulo: nombres[id_pelicula], vistas: count } }
    mas_vistos_nombre.sort_by { |c| [-c[:vistas], c[:titulo]] }.first(3)
  rescue StandardError => _e
    raise
  end

  private

  def contar_vistas_por_id(visualizaciones)
    visualizaciones.each_with_object(Hash.new(0)) do |v, mas_vistos|
      mas_vistos[v.pelicula.id] += 1
    end
  end

  def nombres_por_id(visualizaciones)
    visualizaciones.each_with_object({}) do |v, nombres|
      nombres[v.pelicula.id] = v.pelicula.titulo
    end
  end
end
