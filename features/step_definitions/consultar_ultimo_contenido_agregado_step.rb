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

# Cuando
# =========================================================

Cuando('solicito ver las ultimas peliculas cargadas') do
  @response = Faraday.get('/contenidos/ultimosagregados', { 'Content-Type' => 'application/json' })
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
