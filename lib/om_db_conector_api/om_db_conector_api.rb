require 'faraday'

class OMDbConectorAPI
  API_URL = ENV['OMDB_API_URL']
  API_KEY = ENV['OMDB_API_KEY']

  def detallar_contenido(titulo, logger = nil)
    logger&.info("[OMDb API Request] : Titulo: #{titulo}")

    respuesta_omdb = Faraday.get(API_URL, { t: titulo, apikey: API_KEY })

    logger&.info("[OMDb API Response] : Status: #{respuesta_omdb.status}  Body: #{respuesta_omdb.body}")
  end
end
