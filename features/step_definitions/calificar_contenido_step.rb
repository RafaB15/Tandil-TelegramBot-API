# Dado
# =========================================================

Dado('que el usuario ya vio la pelicula {string} {int} {string}') do |titulo, anio, genero|
  request_body = { titulo:, anio:, genero: }.to_json
  response_pelicula = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
  @id_contenido = JSON.parse(response_pelicula.body)['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  email = json_response_usuario['email']
  @id_telegram = json_response_usuario['id_telegram']

  fecha = Time.now.floor.iso8601
  id_contenido = @id_contenido
  request_body = { email:, fecha: }.to_json
  Faraday.post("/contenidos/#{id_contenido}/visualizaciones", request_body, { 'Content-Type' => 'application/json' })
end

Dado('que el usuario la habia calificado con un {int}') do |puntaje|
  @puntaje_viejo = puntaje

  request_body = { id_telegram: @id_telegram, id_contenido: @id_contenido, puntaje: }.to_json
  @response_calificaciones = Faraday.post('/calificaciones', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existe el contenido {string} {int} {string} y el usuario no lo vio') do |titulo, anio, genero|
  request_body = { titulo:, anio:, genero: }.to_json
  @response_pelicula = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('califica la pelicula con un {int}') do |puntaje|
  @puntaje = puntaje

  request_body = { id_telegram: @id_telegram, id_contenido: @id_contenido, puntaje: }.to_json
  @response_calificaciones = Faraday.post('/calificaciones', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('el usuario quiere calificar con {int} un contenido que no existe en la base de datos') do |puntaje|
  @puntaje = puntaje

  request_body = { id_telegram: @id_telegram, id_contenido: 11_111_111, puntaje: }.to_json
  @response_calificaciones = Faraday.post('/calificaciones', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('califica la pelicula con un {int} se actualiza') do |nuevo_puntaje|
  @nuevo_puntaje = nuevo_puntaje

  request_body = { id_telegram: @id_telegram, id_contenido: @id_contenido, puntaje: nuevo_puntaje }.to_json
  @response_calificaciones = Faraday.post('/calificaciones', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('califica una pelicula que no vio con un {int}') do |puntaje|
  @puntaje = puntaje

  @id_contenido = JSON.parse(@response_pelicula.body)['id']
  request_body = { id_telegram: @id_telegram, id_contenido: @id_contenido, puntaje: }.to_json
  @response_calificaciones = Faraday.post('/calificaciones', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('ve un mensaje de exito') do
  expect(@response_calificaciones.status).to eq 201

  json_response = JSON.parse(@response_calificaciones.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_telegram']).to eq @id_telegram
  expect(json_response['id_contenido']).to eq @id_contenido
  expect(json_response['puntaje']).to eq @puntaje
end

Entonces('ve un mensaje de calificacion fuera de rango') do
  expect(@response_calificaciones.status).to eq 422
end

Entonces('ve un mensaje de que el contenido a calificar no existe') do
  expect(@response_calificaciones.status).to eq 404
end

Entonces('ve un mensaje que el la calificacion fue actualizada') do
  expect(@response_calificaciones.status).to eq 200

  json_response = JSON.parse(@response_calificaciones.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_telegram']).to eq @id_telegram
  expect(json_response['id_contenido']).to eq @id_contenido
  expect(json_response['puntaje']).to eq @nuevo_puntaje
  expect(json_response['puntaje_anterior']).to eq @puntaje_viejo
end

Entonces('ve un mensaje de que la pelicula no fue vista') do
  expect(@response_calificaciones.status).to eq 422
end

Entonces('ve un mensaje de calificación exitosa') do
  expect(@response_calificaciones.status).to eq 201
end
