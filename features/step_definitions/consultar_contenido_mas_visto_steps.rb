# Dado
# =========================================================

# Primera prueba de aceptacion

Dado('que existe un usuario con email {string} y id_telegram {int}') do |email, id_telegram|
  request_body = { email:, id_telegram: }.to_json
  @response_usuario = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que existen 3 peliculas en la plataforma') do
  @tipo = 'pelicula'

  @request_pelicula_body1 = { titulo: 'Nahir', anio: 2024, genero: 'drama', tipo: @tipo }.transform_keys(&:to_s)
  @response_pelicula1 = Faraday.post('/contenidos', @request_pelicula_body1.to_json, { 'Content-Type' => 'application/json' })

  @request_pelicula_body2 = { titulo: 'Amor', anio: 2001, genero: 'comedia', tipo: @tipo }.transform_keys(&:to_s)
  @response_pelicula2 = Faraday.post('/contenidos', @request_pelicula_body2.to_json, { 'Content-Type' => 'application/json' })

  @request_pelicula_body3 = { titulo: 'Batman', anio: 1998, genero: 'accion', tipo: @tipo }.transform_keys(&:to_s)
  @response_pelicula3 = Faraday.post('/contenidos', @request_pelicula_body3.to_json, { 'Content-Type' => 'application/json' })
end

Dado('que hay 3 peliculas vistos en la plataforma') do
  json_response_usuario = JSON.parse(@response_usuario.body)
  @email = json_response_usuario['email']

  json_response_pelicula1 = JSON.parse(@response_pelicula1.body)
  @id_pelicula1 = json_response_pelicula1['id']

  json_response_pelicula2 = JSON.parse(@response_pelicula2.body)
  @id_pelicula2 = json_response_pelicula2['id']

  json_response_pelicula3 = JSON.parse(@response_pelicula3.body)
  @id_pelicula3 = json_response_pelicula3['id']

  # Este contenido es visto 3 veces
  3.times do |_i|
    @fecha1 = Time.now.floor.iso8601
    request_body1 = { email: @email, fecha: @fecha1 }.to_json
    id_contenido = @id_pelicula1
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body1, { 'Content-Type' => 'application/json' })
  end

  # Este contenido es visto 2 veces
  2.times do |_i|
    @fecha2 = Time.now.floor.iso8601
    request_body2 = { email: @email, fecha: @fecha2 }.to_json
    id_contenido = @id_pelicula2
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body2, { 'Content-Type' => 'application/json' })
  end

  # Este contenido es visto 1 vez
  @fecha3 = Time.now.floor.iso8601
  request_body3 = { email: @email, fecha: @fecha3 }.to_json
  id_contenido = @id_pelicula3
  @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body3, { 'Content-Type' => 'application/json' })
end

Dado('que se vio el contenido {string}') do |titulo|
  @response_busqueda = Faraday.get('/contenidos', titulo:, 'Content-Type' => 'application/json')
  json_response = JSON.parse(@response_busqueda.body)
  expect(json_response.length).to eq 1
  json_usuario = JSON.parse(@response_usuario.body)
  email = json_usuario['email']
  @id_contenido = json_response[0]['id']
  request_body = { email:, fecha: Time.now.floor.iso8601 }.to_json
  @response = Faraday.post("contenidos/#{@id_contenido}/visualizaciones", request_body, { 'Content-Type' => 'application/json' })
end

# Segunda prueba de aceptacion

Dado('que hay 4 peliculas: {string}, {string}, {string}, {string}') do |titulo1, titulo2, titulo3, titulo4|
  @tipo = 'pelicula'

  @request_pelicula_body1 = { titulo: titulo1, anio: 2024, genero: 'drama', tipo: @tipo }.transform_keys(&:to_s)
  @response_contenido1 = Faraday.post('/contenidos', @request_pelicula_body1.to_json, { 'Content-Type' => 'application/json' })

  @request_pelicula_body2 = { titulo: titulo2, anio: 2001, genero: 'comedia', tipo: @tipo }.transform_keys(&:to_s)
  @response_contenido2 = Faraday.post('/contenidos', @request_pelicula_body2.to_json, { 'Content-Type' => 'application/json' })

  @request_pelicula_body3 = { titulo: titulo3, anio: 1998, genero: 'accion', tipo: @tipo }.transform_keys(&:to_s)
  @response_contenido3 = Faraday.post('/contenidos', @request_pelicula_body3.to_json, { 'Content-Type' => 'application/json' })

  @request_pelicula_body4 = { titulo: titulo4, anio: 1998, genero: 'accion', tipo: @tipo }.transform_keys(&:to_s)
  @response_contenido4 = Faraday.post('/contenidos', @request_pelicula_body4.to_json, { 'Content-Type' => 'application/json' })
end

Dado('que los 4 peliculas son los mas vistos en la plataforma con la misma cantidad de vistas') do
  json_response_usuario = JSON.parse(@response_usuario.body)
  @email = json_response_usuario['email']

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

    request_body1 = { email: @email, fecha: }.to_json
    id_contenido = @id_pelicula1
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body1, { 'Content-Type' => 'application/json' })

    request_body2 = { email: @email, fecha: }.to_json
    id_contenido = @id_pelicula2
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body2, { 'Content-Type' => 'application/json' })

    request_body3 = { email: @email, fecha: }.to_json
    id_contenido = @id_pelicula3
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body3, { 'Content-Type' => 'application/json' })

    request_body4 = { email: @email, fecha: }.to_json
    id_contenido = @id_pelicula4
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body4, { 'Content-Type' => 'application/json' })
  end
end

Dado('que solo hay 2 peliculas que obtuvieron visualizaciones') do
  json_response_usuario = JSON.parse(@response_usuario.body)
  @email = json_response_usuario['email']

  json_response_pelicula1 = JSON.parse(@response_pelicula1.body)
  @id_pelicula1 = json_response_pelicula1['id']

  json_response_pelicula2 = JSON.parse(@response_pelicula2.body)
  @id_pelicula2 = json_response_pelicula2['id']

  # Este contenido es visto 3 veces
  3.times do |_i|
    @fecha1 = Time.now.floor.iso8601
    request_body1 = { email: @email, fecha: @fecha1 }.to_json
    id_contenido = @id_pelicula1
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body1, { 'Content-Type' => 'application/json' })
  end

  # Este contenido es visto 2 veces
  2.times do |_i|
    @fecha2 = Time.now.floor.iso8601
    request_body2 = { email: @email, fecha: @fecha2 }.to_json
    id_contenido = @id_pelicula2
    @response = Faraday.post("contenidos/#{id_contenido}/visualizaciones", request_body2, { 'Content-Type' => 'application/json' })
  end
end

# Cuando
# =========================================================

Cuando('se consulta por la lista de contenidos mas vistos') do
  @response = Faraday.get('/visualizaciones/top', { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('se ve una lista de los 3 peliculas mas vistos') do
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 3
  expect(@response.status).to eq 200
  expect(json_response[0]['id']).to be > 0
  expect(json_response[1]['id']).to be > 0
  expect(json_response[2]['id']).to be > 0
  expect(json_response[0]['vistas']).to be > 0
  expect(json_response[1]['vistas']).to be > 0
  expect(json_response[2]['vistas']).to be > 0
end

Entonces('se ve una lista de los 3 peliculas más vistos, seleccionados alfabéticamente: {string}, {string}, {string}') do |titulo1, titulo2, titulo4|
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 3
  expect(@response.status).to eq 200
  expect(json_response[0]['id']).to be > 0
  expect(json_response[1]['id']).to be > 0
  expect(json_response[2]['id']).to be > 0
  expect(json_response[0]['vistas']).to be > 0
  expect(json_response[1]['vistas']).to be > 0
  expect(json_response[2]['vistas']).to be > 0
  expect(@request_pelicula_body1['titulo']).to eq titulo1
  expect(@request_pelicula_body2['titulo']).to eq titulo2
  expect(@request_pelicula_body4['titulo']).to eq titulo4
end

Entonces('se ve una lista de 2 peliculas') do
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 2
  expect(@response.status).to eq 200
  expect(json_response[0]['id']).to be > 0
  expect(json_response[1]['id']).to be > 0
  expect(json_response[0]['vistas']).to be > 0
  expect(json_response[1]['vistas']).to be > 0
end

Entonces('tengo un listado de vistos vacio') do
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 0
  expect(@response.status).to eq 200
end

Entonces('{string} está en la lista') do |titulo|
  expect(@response.status).to eq 200

  json_response = JSON.parse(@response.body)
  expect(json_response.length).to be > 0

  json_response.each do |contenido|
    expect(contenido['contenido']['titulo']).not_to be_nil
    if contenido['contenido']['titulo'] == titulo
      expect(contenido['contenido']['titulo']).to eq titulo
      break
    end
  end
end

Entonces('{string} no está en la lista') do |titulo|
  expect(@response.status).to eq 200

  json_response = JSON.parse(@response.body)
  expect(json_response.length).to be > 0

  json_response.each do |contenido|
    expect(contenido['contenido']['titulo']).not_to be_nil
    if contenido['contenido']['titulo'] == titulo
      expect(contenido['contenido']['titulo']).not_to eq titulo
      break
    end
  end
end
