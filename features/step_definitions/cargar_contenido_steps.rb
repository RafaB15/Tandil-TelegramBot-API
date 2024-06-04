# Dado
# =========================================================

# Cuando
# =========================================================

Cuando('cargo {string} {int} {string}') do |titulo, anio, genero|
  @titulo = titulo
  @anio = anio
  @genero = genero

  request_body = { titulo:, anio:, genero: }.to_json

  @response = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {string} {string}') do |titulo, genero|
  @titulo = titulo
  @genero = genero

  request_body = { titulo:, genero: }.to_json

  @response = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('deberia devolver un resultado exitoso') do
  expect(@response.status).to eq(201)

  json_response = JSON.parse(@response.body)

  expect(json_response['id']).to be > 0
  expect(json_response['titulo']).to eq(@titulo)
  expect(json_response['anio']).to eq(@anio)
  expect(json_response['genero']).to eq(@genero)
end

Entonces('deberia devolver solicitud incorrecta y un mensaje de error {string}') do |error_message|
  expect(@response.status).to eq(400)

  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Solicitud Incorrecta'
  expect(json_response['message']).to eq error_message
end
