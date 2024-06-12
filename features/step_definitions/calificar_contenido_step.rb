# Dado
# =========================================================

Dado('que el usuario ya vio la pelicula {string} {int} {string}') do |titulo, anio, genero|
  request_body = { titulo:, anio:, genero: }.to_json
  response_pelicula = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
  @id_pelicula = JSON.parse(response_pelicula.body)['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  email = json_response_usuario['email']
  @id_telegram = json_response_usuario['id_telegram']

  fecha = Time.now.floor.iso8601
  request_body = { email:, id_pelicula: @id_pelicula, fecha: }.to_json
  Faraday.post('/visualizacion', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que el usuario la habia calificado con un {int}') do |calificacion|
  @calificacion = calificacion

  request_body = { id_telegram: @id_telegram, id_pelicula: @id_pelicula, calificacion: }.to_json
  @response_calificacion = Faraday.post('/calificacion', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existe el contenido {string} {int} {string} y el usuario no lo vio') do |titulo, anio, genero|
  request_body = { titulo:, anio:, genero: }.to_json
  @response_pelicula = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('califica la pelicula con un {int}') do |calificacion|
  @calificacion = calificacion

  request_body = { id_telegram: @id_telegram, id_pelicula: @id_pelicula, calificacion: }.to_json
  @response_calificacion = Faraday.post('/calificacion', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('el usuario quiere calificar con {int} un contenido que no existe en la base de datos') do |calificacion|
  @calificacion = calificacion

  request_body = { id_telegram: @id_telegram, id_pelicula: 11_111_111, calificacion: }.to_json
  @response_calificacion = Faraday.post('/calificacion', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('califica la pelicula con un {int} se actualiza') do |nueva_calificacion|
  @nueva_calificacion = nueva_calificacion

  request_body = { id_telegram: @id_telegram, id_pelicula: @id_pelicula, calificacion: nueva_calificacion }.to_json
  @response_calificacion_actualizada = Faraday.put('/calificacion', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('califica una pelicula que no vio con un {int}') do |calificacion|
  @calificacion = calificacion

  @id_pelicula = JSON.parse(@response_pelicula.body)['id']
  request_body = { id_telegram: @id_telegram, id_pelicula: @id_pelicula, calificacion: }.to_json
  @response_calificacion = Faraday.post('/calificacion', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('ve un mensaje de exito') do
  expect(@response_calificacion.status).to eq 201

  json_response = JSON.parse(@response_calificacion.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_telegram']).to eq @id_telegram
  expect(json_response['id_pelicula']).to eq @id_pelicula
  expect(json_response['calificacion']).to eq @calificacion
end

Entonces('ve un mensaje de calificacion fuera de rango') do
  expect(@response_calificacion.status).to eq 422
end

Entonces('ve un mensaje de que el contenido a calificar no existe') do
  expect(@response_calificacion.status).to eq 404
end

Entonces('ve un mensaje que el la calificacion fue actualizada') do
  expect(@response_calificacion_actualizada.status).to eq 201

  json_response = JSON.parse(@response_calificacion_actualizada.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_telegram']).to eq @id_telegram
  expect(json_response['id_pelicula']).to eq @id_pelicula
  expect(json_response['calificacion']).to eq @nueva_calificacion
end

Entonces('ve un mensaje de que la pelicula no fue vista') do
  expect(@response_calificacion.status).to eq 422
end
