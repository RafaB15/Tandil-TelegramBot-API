# Dado
# =========================================================

Dado('que existe un usuario con email "fer@gmail.com" y telegram_id 123456789') do |email, telegram_id|
  @email = email
  @telegram_id = telegram_id

  request_body = { email:, telegram_id: }.to_json
  @response_usuario = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existen 3 contenidos en la plataforma') do
  request_body1 = { titulo: 'Nahir', anio: 2024, genero: 'drama' }.to_json
  @response_pelicula1 = Faraday.post('/contenido', request_body1, { 'Content-Type' => 'application/json' })

  request_body2 = { titulo: 'Amor', anio: 2001, genero: 'comedia' }.to_json
  @response_pelicula2 = Faraday.post('/contenido', request_body2, { 'Content-Type' => 'application/json' })

  request_body3 = { titulo: 'Batman', anio: 1998, genero: 'accion' }.to_json
  @response_pelicula3 = Faraday.post('/contenido', request_body3, { 'Content-Type' => 'application/json' })
end

Dado('que hay 3 contenidos vistos en la plataforma') do
  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_usuario = json_response_usuario['id']

  json_response_pelicula1 = JSON.parse(@response_pelicula1.body)
  @id_pelicula1 = json_response_pelicula1['id']

  json_response_pelicula2 = JSON.parse(@response_pelicula2.body)
  @id_pelicula2 = json_response_pelicula2['id']

  json_response_pelicula3 = JSON.parse(@response_pelicula3.body)
  @id_pelicula3 = json_response_pelicula3['id']

  3.times do |_i|
    @fecha1 = Time.now.floor.iso8601
    request_body1 = { id_usuario: @id_usuario, id_pelicula: @id_pelicula1, fecha: @fecha1 }.to_json
    @response = Faraday.post('/visualizacion', request_body1, { 'Content-Type' => 'application/json' })
  end

  2.times do |_i|
    @fecha2 = Time.now.floor.iso8601
    request_body2 = { id_usuario: @id_usuario, id_pelicula: @id_pelicula2, fecha: @fecha2 }.to_json
    @response = Faraday.post('/visualizacion', request_body2, { 'Content-Type' => 'application/json' })
  end

  @fecha3 = Time.now.floor.iso8601
  request_body3 = { id_usuario: @id_usuario, id_pelicula: @id_pelicula3, fecha: @fecha3 }.to_json
  @response = Faraday.post('/visualizacion', request_body3, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('se consulta por la lista de contenidos mas vistos') do
  @response = Faraday.get('/visualizacion/top3', { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('se ve una lista de los 3 contenidos mas vistos') do
  json_response = JSON.parse(@response.body)

  expect(json_response[0]['id_pelicula']).to eq @id_pelicula1
  expect(json_response[1]['id_pelicula']).to eq @id_pelicula2
  expect(json_response[2]['id_pelicula']).to eq @id_pelicula3
end
