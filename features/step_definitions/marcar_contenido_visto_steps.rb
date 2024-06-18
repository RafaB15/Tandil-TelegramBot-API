# Dado
# =========================================================

Dado('un usuario {string} {int}') do |email, id_telegram|
  request_body = { email:, id_telegram: }.to_json
  @response_usuario = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existe el contenido {string} {int} {string} {string}') do |titulo, anio, genero, tipo|
  request_body = { titulo:, anio:, genero:, tipo: }.to_json
  @response_pelicula = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existe la pelicula {string} {int} {string} en la base de datos') do |titulo, anio, genero|
  @request_temporada = { titulo:, anio:, genero:, tipo: 'pelicula' }.to_json
  @response_contenido = Faraday.post('/contenidos', @request_temporada, { 'Content-Type' => 'application/json' })
end

Dado('que existe la temporada {string} {int} {string} {int} en la base de datos') do |titulo, anio, genero, cantidad_capitulos|
  @request_temporada = { titulo:, anio:, genero:, tipo: 'serie', cantidad_capitulos: }.to_json
  @response_contenido = Faraday.post('/contenidos', @request_temporada, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('el usuario lo visualiza') do
  # nada que hacer
end

Cuando('el administrador marca el capitulo {int} de la temporada como visto para el usuario') do |numero_capitulo|
  body_contenido = JSON.parse(@response_contenido.body)
  @body_usuario = JSON.parse(@response_usuario.body)
  @body_visualizacion = { email: @body_usuario['email'], fecha: Time.now.floor.iso8601, numero_capitulo: }.to_json
  @id_contenido = body_contenido['id']
  @response = Faraday.post("contenidos/#{@id_contenido}/visualizaciones", @body_visualizacion, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('el administrador debería poder marcar el contenido como visto para ese usuario') do
  json_response_usuario = JSON.parse(@response_usuario.body)
  @email = json_response_usuario['email']

  json_response_pelicula = JSON.parse(@response_contenido.body)
  @id_contenido = json_response_pelicula['id']

  @fecha = Time.now.floor.iso8601

  request_body = { email: @email, id_contenido: @id_contenido, fecha: @fecha }.to_json
  id_contenido = @id_contenido
  @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body, { 'Content-Type' => 'application/json' })
end

Entonces('deberia ver un mensaje de la visualizacion cargada exitosamente') do
  expect(@response.status).to eq 201

  json_response = JSON.parse(@response.body)

  expect(json_response['id']).to be > 0
  expect(json_response['email']).to eq @email
  expect(json_response['id_contenido']).to eq @id_contenido
  expect(json_response['fecha']).to eq @fecha
end

Entonces('se deberia ver un mensaje de la visualizacion cargada exitosamente') do
  json_response = JSON.parse(@response.body)
  body_visualizacion = JSON.parse(@body_visualizacion)

  expect(@response.status).to eq 201

  expect(json_response['id']).to be > 0
  expect(json_response['email']).to eq body_visualizacion['email']
  expect(json_response['id_contenido']).to eq @id_contenido
  expect(json_response['fecha']).to eq body_visualizacion['fecha']
  expect(json_response['numero_capitulo']).to eq body_visualizacion['numero_capitulo']
end

Entonces('la serie {string} se contabiliza como vista') do |titulo_serie|
  @response = Faraday.get('/visualizaciones/top', { 'Content-Type' => 'application/json' })
  json_response = JSON.parse(@response.body)

  expect(@response.status).to eq 200

  expect(json_response.length).to eq 1
  expect(json_response[0]['contenido']['titulo']).to eq titulo_serie
end

Entonces('la serie {string} NO se contabiliza como vista') do |_titulo_serie|
  @response = Faraday.get('/visualizaciones/top', { 'Content-Type' => 'application/json' })
  json_response = JSON.parse(@response.body)

  expect(@response.status).to eq 200

  expect(json_response.length).to eq 0
end
