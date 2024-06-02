# Dado
# =========================================================

# Cuando
# =========================================================

Cuando('cargo {string} {int} {string}') do |titulo, anio, genero|
  @titulo = titulo
  @anio = anio
  @genero = genero

  request_body = { titulo:, anio:, genero: }.to_json
  @response = Faraday.post('/peliculas', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('deberia devolver un resultado exitoso') do
  json_response = JSON.parse(@response.body)
  pelicula = RepositorioPeliculas.new.find(json_response['id'])

  expect(@response.status).to eq(201)

  expect(pelicula.titulo).to eq(@titulo)
  expect(pelicula.anio).to eq(@anio)
  expect(pelicula.genero).to eq(@genero)
end
