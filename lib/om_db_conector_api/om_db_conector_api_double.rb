class OMDbConectorAPIDouble
  def detallar_pelicula(_titulo)
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
  end
end
