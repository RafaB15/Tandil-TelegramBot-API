class OMDbConectorAPIDouble
  def detallar_contenido(titulo, _logger = nil)
    estado = 200

    case titulo
    when 'Titanic'
      cuerpo = respuesta_exito_pelicula
    when 'PeliculaSinDirectorNiPremiosEnOMDB'
      cuerpo = respuesta_con_na_pelicula
    when 'EstaPeliNoExisteEnOMDB'
      cuerpo = repuesta_contenido_inexistente_en_omdb
    when 'The Good Doctor'
      cuerpo = respuesta_exito_serie
    when 'EstaSerieNoExisteEnOMDB'
      cuerpo = repuesta_contenido_inexistente_en_omdb
    when 'Friends'
      cuerpo = respuesta_con_na_serie
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

  def respuesta_con_na_pelicula
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
      'Year' => '2017–2024',
      'Director' => 'N/A',
      'Plot' => 'Shaun Murphy, a young surgeon with autism and Savant syndrome, is recruited into the surgical unit of a prestigious hospital.',
      'Awards' => '6 wins & 29 nominations'
    }
  end

  def respuesta_con_na_serie
    {
      'Title' => 'Friends',
      'Year' => '1994–2004',
      'Director' => 'N/A',
      'Plot' => 'Follows the personal and professional lives of six twenty to thirty year-old friends living in the Manhattan borough of New York City.',
      'Awards' => 'Won 6 Primetime Emmys. 79 wins & 231 nominations total'
    }
  end
end
