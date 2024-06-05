# Dado
# =========================================================

Dado('que el contenido {string} {int} {string} existe en la base de datos') do |titulo, anio, genero|
  @titulo = titulo
  @anio = anio
  @genero = genero

  request_body = { titulo:, anio:, genero: }.to_json

  @response_pelicula = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('el usuario aniade un contenido {string} a favoritos') do |_contenido|
  json_response_usuario = JSON.parse(@response_usuario.body)
  @email = json_response_usuario['email']

  json_response_pelicula = JSON.parse(@response_pelicula.body)
  @id_pelicula = json_response_pelicula['id']

  request_body = { email: @email, id_contenido: @id_pelicula }.to_json

  @response = Faraday.post('/favorito', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('ve un mensaje de exito al aniadir la pelicula a favoritos') do
  expect(@response.status).to eq 201

  json_response = JSON.parse(@response.body)

  expect(json_response['id']).to be > 0
  expect(json_response['email']).to eq @email
  expect(json_response['id_contenido']).to eq @id_pelicula
end
