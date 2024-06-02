# Dado
# =========================================================

# Cuando
# =========================================================

Cuando('cargo {string} {string} {string}') do |nombre, anio, genero|
  @nombre = nombre
  @anio = anio
  @genero = genero

  request_body = { nombre:, anio:, genero: }.to_json
  @response = Faraday.post('/contenidos', request_body, { 'Content-Type' => 'application/json' })
  @response = JSON.parse(@response.body)
end

# Entonces
# =========================================================

Entonces('deberia devolver un mensaje exitoso {string}') do |mensaje|
  expect(@response['mensaje']).to eq(mensaje)
  expect(@response.status).to eq(201)
  expect(@response['content_added']).to eq({ nombre: @nombre, anio: @anio, genero: @genero })
end
