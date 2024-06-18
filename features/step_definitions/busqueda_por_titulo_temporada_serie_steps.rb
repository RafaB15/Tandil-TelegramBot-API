# Dado
# =========================================================

Dado('que existe la temporada {string} {int} {string} {int} existe en la base de datos') do |temporada, anio, genero, cantidad_capitulos|
  @titulo_temporada = temporada
  @anio = anio
  @genero = genero
  @cantidad_capitulos = cantidad_capitulos

  request_body = { titulo: temporada, anio:, genero:, cantidad_capitulos: }.to_json

  @response_temporada = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('el usuario busca la temporada {string}') do |titulo_temporada|
  @response = Faraday.get('/contenidos', titulo: titulo_temporada, 'Content-Type' => 'application/json')
end

# Entonces
# =========================================================

Entonces('deberia ver la temporada {string} listada entre las existentes') do |titulo|
  @contenidos = JSON.parse(@response.body)
  expect(@response.status).to eq 200
  expect(@contenidos.length).to eq 1
  expect(@contenidos[0]['titulo']).to eq titulo
end
