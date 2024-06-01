# Dado
# =========================================================

Dado('que no estoy registrado') do
  # nada que hacer
end

# Cuando
# =========================================================

Cuando('creo un usuario de nombre {string} con el email {string} y telegram ID {int}') do |_nombre, email, telegram_id|
  @email = email
  @telegram_id = telegram_id

  request_body = { email:, telegram_id: }.to_json
  @response = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

# Entonces
# =========================================================

Entonces('debería ver un mensaje de bienvenida') do
  expect(@response.status).to eq 201
end

Entonces('quedo registrado') do
  json_response = JSON.parse(@response.body)
  usuario = RepositorioUsuarios.new.find(json_response['id'])
  expect(usuario.email).to eq @email
  expect(usuario.telegram_id).to eq @telegram_id
end

Entonces('debería ver un mensaje de email inválido') do
  expect(@response.status).to eq 422
  json_response = JSON.parse(@response.body)

  expect(json_response['details'][0]['field']).to eq 'email'
end
