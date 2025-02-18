# Dado
# =========================================================

Dado('que ya esta cargada la pelicula {string} {int} {string} {string}') do |titulo, anio, genero, tipo|
  @titulo = titulo
  @anio = anio
  @genero = genero
  @tipo = tipo

  request_body = { titulo:, anio:, genero:, tipo: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que ya esta cargada la pelicula {string} {int} {string} {string} {int}') do |titulo, anio, genero, tipo, cantidad_capitulos|
  @titulo = titulo
  @anio = anio
  @genero = genero
  @tipo = tipo
  @cantidad_capitulos = cantidad_capitulos

  request_body = { titulo:, anio:, genero:, tipo:, cantidad_capitulos: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('cargo {string} {int} {string} {string}') do |titulo, anio, genero, tipo|
  @titulo = titulo
  @anio = anio
  @genero = genero
  @tipo = tipo

  request_body = { titulo:, anio:, genero:, tipo: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {string} {int} {string} {string} {int}') do |titulo, anio, genero, tipo, cantidad_capitulos|
  @titulo = titulo
  @anio = anio
  @genero = genero
  @tipo = tipo
  @cantidad_capitulos = cantidad_capitulos

  request_body = { titulo:, anio:, genero:, tipo:, cantidad_capitulos: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {string} {string} {string}') do |titulo, genero, tipo|
  @titulo = titulo
  @genero = genero
  @tipo = tipo

  request_body = { titulo:, genero:, tipo: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {string} {string} {string} {int}') do |titulo, genero, tipo, cantidad_capitulos|
  @titulo = titulo
  @genero = genero
  @tipo = tipo
  @cantidad_capitulos = cantidad_capitulos

  request_body = { titulo:, genero:, tipo:, cantidad_capitulos: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {int} {string} {string}') do |anio, genero, tipo|
  @anio = anio
  @genero = genero
  @tipo = tipo

  request_body = { anio:, genero:, tipo: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {int} {string} {string} {int}') do |anio, genero, tipo, cantidad_capitulos|
  @anio = anio
  @genero = genero
  @tipo = tipo
  @cantidad_capitulos = cantidad_capitulos

  request_body = { anio:, genero:, tipo:, cantidad_capitulos: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {string} {int} {string} {string} ya es un contenido existente') do |titulo, anio, genero, tipo|
  @titulo = titulo
  @anio = anio
  @genero = genero
  @tipo = tipo

  request_body = { titulo:, anio:, genero:, tipo: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('cargo {string} {int} {string} {string} {int} ya es un contenido existente') do |titulo, anio, genero, tipo, cantidad_capitulos|
  @titulo = titulo
  @anio = anio
  @genero = genero
  @tipo = tipo
  @cantidad_capitulos = cantidad_capitulos

  request_body = { titulo:, anio:, genero:, tipo:, cantidad_capitulos: }.to_json

  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
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
  expect(json_response['tipo']).to eq(@tipo)
  expect(json_response['cantidad_capitulos']).to eq(@cantidad_capitulos)
end

Entonces('deberia devolver solicitud incorrecta \({int}) y un mensaje de error {string}') do |estado, error_message|
  expect(@response.status).to eq(estado)

  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Solicitud Incorrecta'
  expect(json_response['message']).to eq error_message
end

Entonces('en los detalles se debe especificar los generos permitidos') do
  json_response = JSON.parse(@response.body)

  expect(json_response['details']['field']).to eq 'genero'
  expect(json_response['message']).to eq 'El parametro requerido genero debe ser drama, accion o comedia'
end

Entonces('deberia devolver conflicto \({int}) y un mensaje de error {string}') do |estado, error_message|
  expect(@response.status).to eq(estado)

  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Conflicto'
  expect(json_response['message']).to eq error_message
end

Entonces('en los detalles se debe especificar los tipos permitidos') do
  json_response = JSON.parse(@response.body)

  expect(json_response['details']['field']).to eq 'tipo'
  expect(json_response['message']).to eq 'El parametro requerido tipo debe ser pelicula o serie'
end
