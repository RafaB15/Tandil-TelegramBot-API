# Dado
# =========================================================

Dado('que el usuario ya vio la pelicula {string} {int} {string}') do |titulo, anio, genero|
  request_body = { titulo:, anio:, genero: }.to_json
  @response_pelicula = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
  @id_pelicula = JSON.parse(request_body)['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  @email = json_response_usuario['email']
  @id_telegram = json_response_usuario['id']

  @fecha = Time.now.floor.iso8601
  request_body = { email: @email, id_pelicula: @id_pelicula, fecha: @fecha }.to_json
  @response = Faraday.post('/visualizacion', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('califica la pelicula con un {int}') do |calificacion|
  @calificacion = calificacion

  request_body = { id_usuario: @id_telegram, id_pelicula: @id_pelicula, calificacion: }.to_json
  @response_calificacion = Faraday.post('/calificacion', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('ve un mensaje de exito') do
  expect(@response_calificacion.status).to eq 201

  json_response = JSON.parse(@response_calificacion.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_usuario']).to eq @id_telegram
  expect(json_response['id_pelicula']).to eq @id_pelicula
  expect(json_response['calificacion']).to eq @calificacion
end
