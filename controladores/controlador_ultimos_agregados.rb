class ControladorUltimosAgregados < ControladorBase
  def obtener_ultimos_agregados(visualizaciones)
    ultimos_agregados = ContadorDeVistas.new(visualizaciones).obtener_ultimos_agregados
    generar_respuesta(200, ultimos_agregados)
  rescue StandardError => e
    ManejadorDeErrores.new.manejar_error(e)
  end
end
