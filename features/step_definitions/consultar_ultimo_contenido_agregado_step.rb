# Dado
# =========================================================

Dado('que se agrego dos nuevos contenidos esta semana') do
  request_pelicula_body1 = { titulo: 'Titanic', anio: 1989, genero: 'drama' }.to_json
  Faraday.post('/contenido', request_pelicula_body1, { 'Content-Type' => 'application/json' })

  request_pelicula_body2 = { titulo: 'Juliet', anio: 2004, genero: 'comedia' }.to_json
  Faraday.post('/contenido', request_pelicula_body2, { 'Content-Type' => 'application/json' })
end

Dado('que no se agrego contenido nuevo esta semana') do
  # nada que hacer
end

Dado('que se agrego {string} hace {float} dias') do |titulo, dias_previos|
  require 'date'
  fecha = (Date.today - dias_previos).strftime('%Y-%m-%d')
  request_pelicula_body1 = { titulo:, anio: 1989, genero: 'drama', fecha_agregado: fecha }.to_json

  Faraday.post('/contenido', request_pelicula_body1, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('solicito ver las ultimas peliculas cargadas') do
  @response = Faraday.get('/contenidos/ultimos-agregados', { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('visualizo un listado donde se encuentran las peliculas') do
  json_response = JSON.parse(@response.body)

  expect(json_response.length).to eq 2
  expect(@response.status).to eq 200
  expect(json_response[0]['id']).to be > 0
  expect(json_response[1]['id']).to be > 0
  expect(json_response[0]['pelicula']).to eq @request_pelicula_body1
  expect(json_response[1]['pelicula']).to eq @request_pelicula_body2
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
