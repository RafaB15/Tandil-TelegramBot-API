# Dado
# =========================================================

Dado('un usuario {string} {int}') do |email, telegram_id|
  @email = email
  @telegram_id = telegram_id

  request_body = { email:, telegram_id: }.to_json
  @response_usuario = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existe el contenido {string} {int} {string}') do |titulo, anio, genero|
  @titulo = titulo
  @anio = anio
  @genero = genero

  request_body = { titulo:, anio:, genero: }.to_json
  @response_pelicula = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('el usuario lo visualiza') do
  # nada que hacer
end

# Entonces
# =========================================================

Entonces('el administrador debería poder marcar el contenido como visto para ese usuario') do
  json_response_pelicula = JSON.parse(@response_pelicula.body)
  id_pelicula = json_response_pelicula['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  id_usuario = json_response_usuario['id']

  @fecha = Time.now.iso8601

  request_body = { id_pelicula:, id_usuario:, fecha: @fecha }.to_json

  @response = Faraday.post('/visualizacion', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('deberia ver un mensaje de la visualizacion cargada exitosamente') do
  expect(@response.status).to eq 201

  json_response = JSON.parse(@response.body)
  visualizacion = CreadorDeVisualizacion.new.crear_visualizacion(json_response['id'])

  expect(visualizacion.id_usuario).to eq @id_usuario
  expect(visualizacion.id_pelicula).to eq @id_pelicula
  expect(visualizacion.fecha).to eq @fecha
end