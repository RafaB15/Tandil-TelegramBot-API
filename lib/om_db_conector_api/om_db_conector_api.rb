require 'faraday'

class OMDbConectorAPI
  API_URL = 'https://www.omdbapi.com/'.freeze
  API_KEY = ENV['OMDB_API_KEY']

  def detallar_pelicula(titulo)
    respuesta_omdb = Faraday.get(API_URL, { t: titulo, apikey: API_KEY })

    detalles_pelicula = JSON.parse(respuesta_omdb.body)

    {
      estado: respuesta_omdb.status,
      cuerpo: detalles_pelicula
    }
  end
end