# Dado
# =========================================================

Dado('que se agrego un nuevo contenido {string} {string} {string} y {string} {string} {string} esta semana') do |titulo1, anio1, genero1, titulo2, anio2, genero2|
  @titulo1 = titulo1
  @anio1 = anio1
  @genero1 = genero1
  request_pelicula_body1 = { titulo: titulo1, anio: anio1, genero: genero1}.to_json
  Faraday.post('/contenido', request_pelicula_body1, { 'Content-Type' => 'application/json' })

  @titulo2 = titulo2
  @anio2 = anio2
  @genero2 = genero2
  request_pelicula_body2 = { titulo: titulo2, anio: anio2, genero: genero2}.to_json
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
