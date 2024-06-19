# Dado
# =========================================================

Dado('que existe la temporada {string} {int} {string} {int} en la base de datos') do |titulo_temporada, anio, genero, cantidad_capitulos|
  @titulo_temporada = titulo_temporada
  @anio = anio
  @genero = genero
  @cantidad_capitulos = cantidad_capitulos
  @tipo = 'serie'

  request_body = { titulo: @titulo_temporada, anio:, genero:, cantidad_capitulos:, tipo: @tipo }.to_json

  @response_contenido = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('el usuario busca la temporada {string}') do |titulo_temporada|
  @response = Faraday.get('/contenidos', titulo: titulo_temporada, 'Content-Type' => 'application/json')
end

# Entonces
# =========================================================

Entonces('la cantidad de resultados es {int}') do |cantidad|
  @contenidos = JSON.parse(@response.body)
  expect(@response.status).to eq 200
  expect(@contenidos.length).to eq cantidad
end

Entonces('deberia ver la temporada {string} listada entre las existentes') do |titulo|
  @contenidos = JSON.parse(@response.body)
  expect(@response.status).to eq 200
  expect(@contenidos.any? { |contenido| contenido['titulo'] == titulo }).to be true
end
