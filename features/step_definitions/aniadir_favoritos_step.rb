# Dado
# =========================================================

Dado('que el contenido {string} {int} {string} {string} existe en la base de datos') do |titulo, anio, genero, tipo|
  @titulo = titulo
  @anio = anio
  @genero = genero
  @tipo = tipo

  request_body = { titulo:, anio:, genero:, tipo: }.to_json

  @response_contenido = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que el usuario ya vio el contenido') do
  @id_contenido = JSON.parse(@response_contenido.body)['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  email = json_response_usuario['email']
  @id_telegram = json_response_usuario['id_telegram']

  fecha = Time.now.floor.iso8601
  request_body = { email:, fecha: }.to_json
  Faraday.post("/contenidos/#{@id_contenido}/visualizaciones", request_body, { 'Content-Type' => 'application/json' })
end

Dado('que el usuario no vio el contenido') do
  @id_contenido = JSON.parse(@response_contenido.body)['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_telegram = json_response_usuario['id_telegram']
end

Dado('que el usuario no vio la temporada de serie') do
  @id_contenido = JSON.parse(@response_contenido.body)['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_telegram = json_response_usuario['id_telegram']
end

# Cuando
# =========================================================

Cuando('el usuario aniade el contenido a favoritos') do
  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_telegram = json_response_usuario['id_telegram']

  json_response_pelicula = JSON.parse(@response_contenido.body)
  @id_contenido = json_response_pelicula['id']

  request_body = { id_telegram: @id_telegram, id_contenido: @id_contenido }.to_json

  @response = Faraday.post('/favoritos', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('ve un mensaje de exito al aniadir la pelicula a favoritos') do
  expect(@response.status).to eq 201

  json_response = JSON.parse(@response.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_telegram']).to eq @id_telegram
  expect(json_response['id_contenido']).to eq @id_contenido
end

Entonces('el contenido se aniade a favoritos exitosamente') do
  expect(@response.status).to eq 201

  json_response = JSON.parse(@response.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_telegram']).to eq @id_telegram
  expect(json_response['id_contenido']).to eq @id_contenido
end

Entonces('ve un mensaje de error de que la temporada no fue vista') do
  json_response = JSON.parse(@response.body)
  expect(@response.status).to eq 422
  expect(json_response['details']['field']).to eq 'visualizacion'
end
