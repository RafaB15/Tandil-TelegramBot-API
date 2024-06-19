# Dado
# =========================================================

Dado('que el usuario ya vio la temporada de serie') do
  @id_contenido = JSON.parse(@response_contenido.body)['id']

  json_response_usuario = JSON.parse(@response_usuario.body)
  email = json_response_usuario['email']
  @id_telegram = json_response_usuario['id_telegram']

  fecha = Time.now.floor.iso8601
  request_body = { email:, fecha: }.to_json
  Faraday.post("/contenidos/#{@id_contenido}/visualizaciones", request_body, { 'Content-Type' => 'application/json' })
end

Dado('que el usuario no la vio') do
  @id_contenido = JSON.parse(@response_contenido.body)['id']
end

# Cuando
# =========================================================

Cuando('califica la temporada de serie con un {int}') do |int|
  @puntaje = int

  request_body = { id_telegram: @id_telegram, id_contenido: @id_contenido, puntaje: @puntaje }.to_json
  @response_calificaciones = Faraday.post('/calificaciones', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('ve un mensaje de calificacion exitosa') do
  expect(@response_calificaciones.status).to eq 201

  json_response = JSON.parse(@response_calificaciones.body)

  expect(json_response['id']).to be > 0
  expect(json_response['id_telegram']).to eq @id_telegram
  expect(json_response['id_contenido']).to eq @id_contenido
  expect(json_response['puntaje']).to eq @puntaje
end

Entonces('ve un mensaje de que la serie no fue vista') do
  json_response = JSON.parse(@response_calificaciones.body)
  expect(@response_calificaciones.status).to eq 422
  expect(json_response['details']['field']).to eq 'visualizacion'
end
