class OMDbConectorAPIDouble
  def detallar_pelicula(titulo, _logger = nil)
    if titulo == 'Titanic'
      {
        'estado' => 200,
        'cuerpo' => {
          'Title' => 'Titanic',
          'Year' => 1997,
          'Director' => 'James Cameron',
          'Plot' => 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
          'Awards' => 'Won 11 Oscars. 126 wins & 83 nominations total'
        }
      }
    elsif titulo == 'peliculasindirectorenOMDB'
      {
        'estado' => 200,
        'cuerpo' => {
          'Title' => 'peliculasindirectorenOMDB',
          'Year' => 2000,
          'Director' => '',
          'Plot' => 'A nice plot',
          'Awards' => 'N/A'
        }
      }
    else
      raise StandardError, 'no hay detalles para mostrar'
    end
  end
end
