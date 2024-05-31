Dado(/que no estoy registrado$/) do
  # nada que hacer
end

Cuando(/^creo un usuario de nombre "(.*?)" con el email "(.*?) y telegram ID "(.*?)"$/) do |_nombre, email, telegram_id|
  @email = email
  @telegrma_id = telegram_id
  request_body = { email:, telegram_id: }.to_json
  @response = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Entonces(/^debería ver un mensaje de bienvenida$/) do
  expect(@response.status).to be 201
end

Entonces(/quedo registrado$/) do
  json_response = JSON.parse(@response.body)
  usuario = RepositorioUsuarios.new.find(json_response['id'])
  expect(usuario.email).to eq @email
  expect(usuario.telegram_id).to eq @telegram_id
end
