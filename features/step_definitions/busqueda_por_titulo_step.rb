# Dado
# =========================================================

# Cuando
# =========================================================

Cuando('el usuario busca la pelicula {string}') do |titulo|
  @response = Faraday.get('/contenido', titulo:, 'Content-Type' => 'application/json')
end

# Entonces
# =========================================================

Entonces('debería ver la película {string} listada entre las existentes') do |titulo|
  @contenidos = JSON.parse(@response.body)
  expect(@response.status).to eq 200
  expect(@contenidos.length).to eq 1
  expect(@contenidos[0]['titulo']).to eq titulo
end

Entonces('debería ver las peliculas {string} y {string} listadas entre las existentes.') do |titulo1, titulo2|
  @contenidos = JSON.parse(@response.body)
  expect(@response.status).to eq 200
  expect(@contenidos.length).to eq 2
  result = (@contenidos[0]['titulo'] == titulo1 && @contenidos[1]['titulo'] == titulo2) ||
           (@contenidos[1]['titulo'] == titulo1 && @contenidos[0]['titulo'] == titulo2)

  expect(result).to be true
end
