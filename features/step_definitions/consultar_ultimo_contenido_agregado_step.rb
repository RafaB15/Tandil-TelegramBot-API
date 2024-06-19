# Dado
# =========================================================

Dado('que se agrego dos nuevos peliculas esta semana {string} {string}') do |titulo1, titulo2|
  request_pelicula_body1 = { titulo: titulo1, anio: 1989, genero: 'drama', tipo: 'pelicula' }.to_json
  Faraday.post('/contenidos', request_pelicula_body1, { 'Content-Type' => 'application/json' })

  request_pelicula_body2 = { titulo: titulo2, anio: 2004, genero: 'comedia', tipo: 'pelicula' }.to_json
  Faraday.post('/contenidos', request_pelicula_body2, { 'Content-Type' => 'application/json' })
end

Dado('que no se agrego contenido nuevo esta semana') do
  # nada que hacer
end

Dado('que se agrego {string} hace {float} dias') do |titulo, dias_previos|
  require 'date'
  fecha = (Date.today - dias_previos).strftime('%Y-%m-%d')
  request_pelicula_body1 = { titulo:, anio: 1989, genero: 'drama', tipo: 'pelicula', fecha_agregado: fecha }.to_json

  Faraday.post('/contenidos', request_pelicula_body1, { 'Content-Type' => 'application/json' })
end

Dado('que se agrego la pelicula {string} hace {float} dias') do |titulo, dias_previos|
  require 'date'
  fecha = (Date.today - dias_previos).strftime('%Y-%m-%d')
  request_pelicula_body1 = { titulo:, anio: 1989, genero: 'drama', tipo: 'pelicula', fecha_agregado: fecha }.to_json

  Faraday.post('/contenidos', request_pelicula_body1, { 'Content-Type' => 'application/json' })
end

Dado('que se agrego la serie {string} hace {float} dias') do |titulo, dias_previos|
  require 'date'
  fecha = (Date.today - dias_previos).strftime('%Y-%m-%d')
  request_serie_body1 = { titulo:, anio: 1989, genero: 'drama', tipo: 'serie', fecha_agregado: fecha, cantidad_capitulos: 20 }.to_json

  Faraday.post('/contenidos', request_serie_body1, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('solicito ver el ultimo contenido cargado') do
  @response = Faraday.get('/contenidos/ultimos-agregados', { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('visualizo un listado donde se encuentran las peliculas {string} {string}') do |titulo1, titulo2|
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 2
  expect(@response.status).to eq 200
  expect(json_response[1]['id']).to be > 0
  expect(json_response[0]['id']).to be > 0
  expect(json_response[1]['pelicula']).to eq @request_pelicula_body1
  expect(json_response[0]['pelicula']).to eq @request_pelicula_body2
  expect(json_response[1]['titulo']).to eq titulo1
  expect(json_response[0]['titulo']).to eq titulo2
end

Entonces('Entonces tengo un listado de vistos vacio') do
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 0
  expect(@response.status).to eq 200
end

Entonces('me muestra {string}') do |titulo|
  json_response = JSON.parse(@response.body)
  expect(json_response.length).to eq 1
  expect(@response.status).to eq 200
  expect(json_response[0]['id']).to be > 0
  expect(json_response[0]['titulo']).to eq titulo
end

Entonces('me muestra {string} en la posicion {int}') do |titulo, posicion|
  json_response = JSON.parse(@response.body)
  expect(@response.status).to eq 200
  expect(json_response[posicion - 1]['id']).to be > 0
  expect(json_response[posicion - 1]['titulo']).to eq titulo
end

Entonces('me muestra {int} peliculas') do |calificacion|
  json_response = JSON.parse(@response.body)
  expect(json_response.length).to eq calificacion
end
