# Dado
# =========================================================
Dado('que no hay contenidos en la BD') do
  # nada que hacer
end

Dado('que el usuario ya lo vio') do
  json_response_usuario = JSON.parse(@response_usuario.body)
  @email = json_response_usuario['email']
  @id_telegram = json_response_usuario['id_telegram']

  json_response_pelicula = JSON.parse(@response_pelicula.body)
  @id_pelicula = json_response_pelicula['id']

  @fecha = Time.now.floor.iso8601

  request_body = { email: @email, id_pelicula: @id_pelicula, fecha: @fecha }.to_json

  @response = Faraday.post('/visualizacion', request_body, { 'Content-Type' => 'application/json' })
end

Dado('que el usuario no lo vio') do
  # nada que hacer
end

# Cuando
# =========================================================

Cuando('el cinefilo pide detalles acerca de la pelicula {string} con su ID') do |titulo|
  if @response_pelicula.nil?
    id_pelicula = 0
  else
    json_response_pelicula = JSON.parse(@response_pelicula.body)
    id_pelicula = json_response_pelicula['id']
  end

  @titulo = titulo

  @response_detalles = Faraday.get("/contenidos/#{id_pelicula}/detalles", id_telegram: @id_telegram, 'Content-Type' => 'application/json')
end

# Entonces
# =========================================================

Entonces('debería ver la informacion esperada') do
  json_response_detalles = JSON.parse(@response_detalles.body)

  expect(json_response_detalles['titulo']).to eq @titulo
  expect(json_response_detalles['anio']).to eq 1997
  expect(json_response_detalles['premios']).to eq 'Won 11 Oscars. 126 wins & 83 nominations total'
  expect(json_response_detalles['director']).to eq 'James Cameron'
  expect(json_response_detalles['sinopsis']).to eq 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.'
end

Entonces('debería ver un mensaje de error de que no está lo que busca') do
  json_response_detalles = JSON.parse(@response_detalles.body)

  expect(json_response_detalles['error']).to eq 'no encontrado'
end

Entonces('debería ver un mensaje que no se pueden mostrar detalles adicionales') do
  json_response_detalles = JSON.parse(@response_detalles.body)
  expect(json_response_detalles['error']).to eq 'no hay detalles para mostrar'
end

Entonces('debería ver el campo {string} como no disponible') do |campo|
  json_response_detalles = JSON.parse(@response_detalles.body)
  expect(json_response_detalles[campo]).to eq ''
end

Entonces('debería mostrar que ya fue visto') do
  json_response_detalles = JSON.parse(@response_detalles.body)
  expect(json_response_detalles['fue_visto']).to eq true
end

Entonces('debería mostrar que no fue visto') do
  json_response_detalles = JSON.parse(@response_detalles.body)
  expect(json_response_detalles['fue_visto']).to eq false
end
