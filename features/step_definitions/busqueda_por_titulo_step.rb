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
