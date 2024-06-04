# Dado
# =========================================================

Dado('que existe un usuario con email {string} y telegram_id {int}') do |email, telegram_id|
  @email = email
  @telegram_id = telegram_id

  request_body = { email:, telegram_id: }.to_json
  @response_usuario = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existen 3 contenidos en la plataforma') do
  @nombre_pelicula1 = 'Nahir'
  request_body1 = { titulo: 'Nahir', anio: 2024, genero: 'drama' }.to_json
  @response_pelicula1 = Faraday.post('/contenido', request_body1, { 'Content-Type' => 'application/json' })

  @nombre_pelicula2 = 'Amor'
  request_body2 = { titulo: 'Amor', anio: 2001, genero: 'comedia' }.to_json
  @response_pelicula2 = Faraday.post('/contenido', request_body2, { 'Content-Type' => 'application/json' })

  @nombre_pelicula3 = 'Batman'
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

Dado('que hay {int} contenidos: {string}, {string}, {string}, {string}') do |_cant_contenidos, c1, c2, c3, c4|
  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_usuario = json_response_usuario['id']

  @nombre_contenido1 = c1
  request_body1 = { titulo: @nombre_contenido1, anio: 2024, genero: 'drama' }.to_json
  @response_contenido1 = Faraday.post('/contenido', request_body1, { 'Content-Type' => 'application/json' })

  @nombre_contenido2 = c2
  request_body2 = { titulo: @nombre_contenido2, anio: 2001, genero: 'comedia' }.to_json
  @response_contenido2 = Faraday.post('/contenido', request_body2, { 'Content-Type' => 'application/json' })

  @nombre_contenido3 = c3
  request_body3 = { titulo: @nombre_contenido3, anio: 1998, genero: 'accion' }.to_json
  @response_contenido3 = Faraday.post('/contenido', request_body3, { 'Content-Type' => 'application/json' })

  @nombre_contenido4 = c4
  request_body4 = { titulo: @nombre_contenido4, anio: 1998, genero: 'accion' }.to_json
  @response_contenido4 = Faraday.post('/contenido', request_body4, { 'Content-Type' => 'application/json' })
end

Dado('que los {int} contenidos son los mas vistos en la plataforma con la misma cantidad de vistas') do |_int|
  json_response_pelicula1 = JSON.parse(@response_contenido1.body)
  @id_pelicula1 = json_response_pelicula1['id']

  json_response_pelicula2 = JSON.parse(@response_contenido2.body)
  @id_pelicula2 = json_response_pelicula2['id']

  json_response_pelicula3 = JSON.parse(@response_contenido3.body)
  @id_pelicula3 = json_response_pelicula3['id']

  json_response_pelicula4 = JSON.parse(@response_contenido4.body)
  @id_pelicula4 = json_response_pelicula4['id']

  5.times do |_i|
    fecha = Time.now.floor.iso8601

    request_body1 = { id_usuario: @id_usuario, id_pelicula: @id_pelicula1, fecha: }.to_json
    @response = Faraday.post('/visualizacion', request_body1, { 'Content-Type' => 'application/json' })

    request_body2 = { id_usuario: @id_usuario, id_pelicula: @id_pelicula2, fecha: }.to_json
    @response = Faraday.post('/visualizacion', request_body2, { 'Content-Type' => 'application/json' })

    request_body3 = { id_usuario: @id_usuario, id_pelicula: @id_pelicula3, fecha: }.to_json
    @response = Faraday.post('/visualizacion', request_body3, { 'Content-Type' => 'application/json' })

    request_body4 = { id_usuario: @id_usuario, id_pelicula: @id_pelicula4, fecha: }.to_json
    @response = Faraday.post('/visualizacion', request_body4, { 'Content-Type' => 'application/json' })
  end
end

# Cuando
# =========================================================

Cuando('se consulta por la lista de contenidos mas vistos') do
  @response = Faraday.get('/visualizacion/top', { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('se ve una lista de los 3 contenidos mas vistos') do
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 3
  expect(@response.status).to eq 200
  expect(json_response[0]['titulo']).to eq @nombre_pelicula1
  expect(json_response[1]['titulo']).to eq @nombre_pelicula2
  expect(json_response[2]['titulo']).to eq @nombre_pelicula3
end

Entonces('se ve una lista de los {int} contenidos más vistos, seleccionados alfabéticamente: {string}, {string}, {string}') do |cant_top, c1, c2, c3|
  json_response = JSON.parse(@response.body)
  puts json_response
  expect(json_response.length).to eq cant_top
  expect(@response.status).to eq 200
  expect(json_response[0]['titulo']).to eq c1
  expect(json_response[1]['titulo']).to eq c2
  expect(json_response[2]['titulo']).to eq c3
end
