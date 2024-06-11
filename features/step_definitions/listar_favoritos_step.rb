# Dado
# =========================================================

Dado('que marco la película {string} como favorita') do |_string|
  json_response_usuario = JSON.parse(@response_usuario.body)
  @id_telegram = json_response_usuario['id_telegram']

  request_body = { id_telegram: @id_telegram, id_contenido: @id_pelicula3 }.to_json

  @response = Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que marco la película {string}, {string} y {string} como favoritas') do |_string, _string2, _string3|
  pending # Write code here that turns the phrase above into concrete actions
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

Entonces('aparece {string}, {string} y {string} en el listado') do |_string, _string2, _string3|
  pending # Write code here that turns the phrase above into concrete actions
end
