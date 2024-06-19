class ConstructorDeDetallesDeContenido
  def initialize
    @contenido = nil
    @premios = nil
    @director = nil
    @sinopsis = nil
    @fue_visto = nil
  end

  def definir_contenido(contenido)
    @contenido = contenido
  end

  def definir_detalles(premios, director, sinopsis)
    @premios = premios
    @director = director
    @sinopsis = sinopsis
  end

  def definir_fue_visto(fue_visto)
    @fue_visto = fue_visto
  end

  def construir
    detalles_de_contenido = DetallesDeContenido.new(@contenido, @premios, @director, @sinopsis)
    detalles_de_contenido.actualizar_fue_visto(@fue_visto)
    detalles_de_contenido
  end
end
