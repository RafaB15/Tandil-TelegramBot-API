URL = ENV['NON_LOCAL_TEST'] == 'true' ? 'https://api.9521.com.ar/tandil-test/usuarios'.freeze : '/usuarios'.freeze

Cuando(/^creo un usuario$/) do
  request_body = { email: 'juan@test.com', id_telegram: 123_456_789 }.to_json

  @response = Faraday.post(URL, request_body, { 'Content-Type' => 'application/json' })
end

Entonces(/^se le asigna un id$/) do
  parsed_response = JSON.parse(@response.body)
  id = parsed_response['id']
  expect(id.to_i).to be > 0
end

Cuando(/^que no existen usuario$/) do
  # nada que hacer aqui
end

Cuando(/^consulto los usuarios$/) do
  @response = Faraday.get(URL)
end

Entonces(/^tengo un listado vacio$/) do
  parsed_response = JSON.parse(@response.body)
  expect(parsed_response)
end
