# Dado
# =========================================================

Dado('que ya esta cargada la pelicula {string} {int} {string}') do |titulo, anio, genero|
  @titulo = titulo
  @anio = anio
  @genero = genero

  request_body = { titulo:, anio:, genero: }.to_json

  @response = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

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

Cuando('cargo {int} {string}') do |anio, genero|
  @anio = anio
  @genero = genero

  request_body = { anio:, genero: }.to_json

  @response = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {string} {int} {string} ya es un contenido existente') do |titulo, anio, genero|
  @titulo = titulo
  @anio = anio
  @genero = genero

  request_body = { titulo:, anio:, genero: }.to_json

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

Entonces('deberia devolver solicitud incorrecta \({int}) y un mensaje de error {string}') do |estado, error_message|
  expect(@response.status).to eq(estado)

  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Solicitud Incorrecta'
  expect(json_response['message']).to eq error_message
end

Entonces('en los detalles se debe especificar los generos permitidos') do
  generos_permitidos = %w[drama accion comedia]

  json_response = JSON.parse(@response.body)

  expect(json_response['details']['field']).to eq 'genero'
  expect(json_response['details']['value']).to eq @genero
  expect(json_response['details']['allowed_values']).to eq generos_permitidos
  expect(json_response['details']['message']).to eq 'El valor proporcionado para \'genero\' debe ser uno de los siguientes: drama, accion, comedia.'
end

Entonces('deberia devolver conflicto \({int}) y un mensaje de error {string}') do |estado, error_message|
  expect(@response.status).to eq(estado)

  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Conflicto'
  expect(json_response['message']).to eq error_message
end
