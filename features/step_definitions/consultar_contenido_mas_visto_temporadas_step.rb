# Dado
# =========================================================

Dado('que se vieron {int} capitulos de la temporada {string}') do |cantidad_capitulos, titulo|
  @response_busqueda = Faraday.get('/contenidos', titulo:, 'Content-Type' => 'application/json')
  json_response = JSON.parse(@response_busqueda.body)
  expect(json_response.length).to eq 1

  @id_contenido = json_response[0]['id']
  (1..cantidad_capitulos).each do |i|
    request_body = { email: @email, fecha: Time.now.floor.iso8601, numero_de_capitulo: i }.to_json
    @response = Faraday.post("contenidos/#{@id_contenido}/visualizaciones", request_body, { 'Content-Type' => 'application/json' })
  end
end

# Cuando
# =========================================================

# Entonces
# =========================================================
