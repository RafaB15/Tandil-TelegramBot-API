# Dado
# =========================================================

Dado('que marco la película {string} como favorita') do |_string|
  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_telegram = json_response_usuario['id_telegram']

  request_body = { id_telegram: @id_telegram, id_contenido: @id_pelicula3 }.to_json

  @response = Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que marco las películas {string}, {string} y {string} como favoritas') do |_titulo1, _titulo2, _titulo3|
  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_telegram = json_response_usuario['id_telegram']

  request_body = { id_telegram: @id_telegram, id_contenido: @id_pelicula1 }.to_json
  Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })

  request_body = { id_telegram: @id_telegram, id_contenido: @id_pelicula2 }.to_json
  Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })

  request_body = { id_telegram: @id_telegram, id_contenido: @id_pelicula3 }.to_json
  Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que marco las películas {string} y {string} como favoritas') do |_string, _string2|
  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_telegram = json_response_usuario['id_telegram']

  request_body = { id_telegram: @id_telegram, id_contenido: @id_pelicula1 }.to_json
  Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })

  request_body = { id_telegram: @id_telegram, id_contenido: @id_pelicula2 }.to_json
  Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que no marco {string} como favorita') do |string|
end

# Cuando
# =========================================================
Cuando('quiero ver mis favoritos') do
  id_telegram = @id_telegram
  @response_favoritos = Faraday.get('/favoritos', id_telegram:, 'Content-Type' => 'application/json')
end

# Entonces
# =========================================================
Entonces('aparece {string} en el listado') do |titulo|
  @favoritos = JSON.parse(@response_favoritos.body)
  expect(@response_favoritos.status).to eq 200
  expect(@favoritos.length).to eq 1
  expect(@favoritos[0]['titulo']).to eq titulo
end

Entonces('aparece {string}, {string} y {string} en el listado') do |titulo1, titulo2, titulo3|
  @favoritos = JSON.parse(@response_favoritos.body)
  expect(@response_favoritos.status).to eq 200
  expect(@favoritos.length).to eq 3
  expect(@favoritos[0]['titulo']).to eq titulo2
  expect(@favoritos[1]['titulo']).to eq titulo3
  expect(@favoritos[2]['titulo']).to eq titulo1
end

Entonces('aparece {string} y {string} en el listado') do |titulo1, titulo2|
  @favoritos = JSON.parse(@response_favoritos.body)
  expect(@response_favoritos.status).to eq 200
  expect(@favoritos.length).to eq 2
  expect(@favoritos[0]['titulo']).to eq titulo1
  expect(@favoritos[1]['titulo']).to eq titulo2
end
