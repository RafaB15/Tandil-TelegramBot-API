class ControladorMasVistos < ControladorBase
  def obtener_mas_vistos(visualizaciones)
    mas_vistos = ContadorDeVistas.new(visualizaciones).obtener_mas_vistos
    generar_respuesta(200, mas_vistos)
  rescue StandardError => e
    ManejadorDeErrores.new.manejar_error(e)
  end
end
