class OMDbConectorAPIDouble
  def detallar_contenido(titulo, _logger = nil)
    estado = 200

    case titulo
    when 'Titanic'
      cuerpo = respuesta_exito_pelicula
    when 'PeliculaSinDirectorNiPremiosEnOMDB'
      cuerpo = respuesta_con_na
    when 'EstaPeliNoExisteEnOMDB'
      cuerpo = repuesta_contenido_inexistente_en_omdb
    when 'The Good Doctor'
      cuerpo = respuesta_exito_serie
    when 'EstaSerieNoExisteEnOMDB'
      cuerpo = repuesta_contenido_inexistente_en_omdb
    else
      estado = 500
      cuerpo = {}
    end

    RespuestaFaradayDouble.new(estado, cuerpo.to_json)
  end

  private

  def respuesta_exito_pelicula
    {
      'Title' => 'Titanic',
      'Year' => 1997,
      'Director' => 'James Cameron',
      'Plot' => 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
      'Awards' => 'Won 11 Oscars. 126 wins & 83 nominations total'
    }
  end

  def respuesta_con_na
    {
      'Title' => 'PeliculaSinDirectorNiPremiosEnOMDB',
      'Year' => 2000,
      'Director' => 'N/A',
      'Plot' => 'A nice plot',
      'Awards' => 'N/A'
    }
  end

  def repuesta_contenido_inexistente_en_omdb
    {
      'Response' => 'False',
      'Error' => 'Movie not found!'
    }
  end

  def respuesta_exito_serie
    {
      'Title' => 'The Good Doctor',
      'Year' => 2017,
      'Director' => 'James Cameron',
      'Plot' => 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
      'Awards' => 'Won 11 Oscars. 126 wins & 83 nominations total'
    }
  end
end
