# Dado
# =========================================================

# Cuando
# =========================================================

Cuando('el cinefilo pide detalles acerca de la pelicula {string} con su ID') do |titulo|
  json_response_pelicula = JSON.parse(@response_pelicula.body)
  id_pelicula = json_response_pelicula['id']

  @titulo = titulo

  @response_detalles = Faraday.get("/contenidos/#{id_pelicula}/detalles", { 'Content-Type' => 'application/json' })
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
