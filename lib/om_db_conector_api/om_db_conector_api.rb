require 'faraday'

class OMDbConectorAPI
  API_URL = 'https://www.omdbapi.com/'.freeze
  API_KEY = ENV['OMDB_API_KEY']

  def detallar_pelicula(titulo, logger = nil)
    logger&.info("[OMDb API Response] : Titulo: #{titulo}   API key #{API_KEY}")

    respuesta_omdb = Faraday.get(API_URL, { t: titulo, apikey: API_KEY })

    logger&.info("[OMDb API Response] : Status: #{respuesta_omdb.status}  Body: #{respuesta_omdb.body}")

    raise StandardError, 'no hay detalles para mostrar' if respuesta_omdb.status != 200

    detalles_pelicula = JSON.parse(respuesta_omdb.body)

    {
      'estado' => respuesta_omdb.status,
      'cuerpo' => detalles_pelicula
    }
  end
end
