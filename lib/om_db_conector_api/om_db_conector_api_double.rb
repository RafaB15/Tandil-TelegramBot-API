class OMDbConectorAPIDouble
  def detallar_pelicula(titulo, _logger = nil)
    estado = 200

    case titulo
    when 'Titanic'
      cuerpo = {
        'Title' => 'Titanic',
        'Year' => 1997,
        'Director' => 'James Cameron',
        'Plot' => 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
        'Awards' => 'Won 11 Oscars. 126 wins & 83 nominations total'
      }
    when 'PeliculaSinDirectorNiPremiosEnOMDB'
      cuerpo = {
        'Title' => 'PeliculaSinDirectorNiPremiosEnOMDB',
        'Year' => 2000,
        'Director' => 'N/A',
        'Plot' => 'A nice plot',
        'Awards' => 'N/A'
      }
    when 'EstaPeliNoExisteEnOMDB'
      cuerpo = {
        'Response' => 'False',
        'Error' => 'Movie not found!'
      }
    else
      estado = 500
      cuerpo = {}
    end

    RespuestaFaradayDouble.new(estado, cuerpo.to_json)
  end
end
