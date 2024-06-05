# Dado
# =========================================================

Dado('que no estoy registrado') do
  # nada que hacer
end

Dado('que creo un usuario con email {string} y telegram ID {int}') do |email, id_telegram|
  @email = email
  @id_telegram = id_telegram

  request_body = { email:, id_telegram: }.to_json
  @response = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

# Cuando
# =========================================================

Cuando('creo un usuario con el email {string} y telegram ID {int}') do |email, id_telegram|
  @email = email
  @id_telegram = id_telegram

  request_body = { email:, id_telegram: }.to_json
  @response = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('creo un usuario con el email {string} y mismo telegram ID que el usuario anterior') do |email|
  request_body = { email:, id_telegram: @id_telegram }.to_json
  @response = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('creo un usuario con el mismo email que el usuario anterior y telegram ID {int}') do |id_telegram|
  request_body = { email: @email, id_telegram: }.to_json
  @response = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('debería ver un mensaje de bienvenida') do
  expect(@response.status).to eq 201
end

Entonces('quedo registrado') do
  json_response = JSON.parse(@response.body)

  expect(json_response['id']).to be > 0
  expect(json_response['email']).to eq @email
  expect(json_response['id_telegram']).to eq @id_telegram
end

Entonces('debería ver un mensaje de email inválido') do
  expect(@response.status).to eq 422
  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Entidad no procesable'
  expect(json_response['details']['field']).to eq 'email'
end

Entonces('debería ver un mensaje de usuario de telegram ya registrado') do
  expect(@response.status).to eq 409
  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Conflicto'
  expect(json_response['details']['field']).to eq 'id_telegram'
end

Entonces('debería ver un mensaje de email ya registrado') do
  expect(@response.status).to eq 409

  json_response = JSON.parse(@response.body)

  expect(json_response['error']).to eq 'Conflicto'
  expect(json_response['details']['field']).to eq 'email'
end
