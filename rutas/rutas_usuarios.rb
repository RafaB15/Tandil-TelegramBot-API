require 'sinatra'

require_relative './utiles'

get '/usuarios' do
  pass unless ENV['APP_MODE'] == 'test'

  settings.logger.debug '[GET] /usuarios - Consultando los usuarios registrados'

  usuarios = RepositorioUsuarios.new.all
  cuerpo = usuarios.map do |u|
    {
      email: u.email,
      id_telegram: u.id_telegram,
      id: u.id
    }
  end

  settings.logger.debug "Respuesta - [Estado] : 200 - [Cuerpo] : #{cuerpo}"

  status 200
  cuerpo.to_json
end

post '/usuarios' do
  @body ||= request.body.read
  parametros_usuario = JSON.parse(@body)
  email = parametros_usuario['email']
  id_telegram = parametros_usuario['id_telegram']

  settings.logger.debug "[POST] /usuarios - Iniciando creación de un nuevo usuario - Body: #{parametros_usuario}"

  repositorio_usuarios = RepositorioUsuarios.new
  plataforma = Plataforma.new

  begin
    usuario = plataforma.registrar_usuario(email, id_telegram, repositorio_usuarios)

    estado = 201
    cuerpo = { id: usuario.id, email: usuario.email, id_telegram: usuario.id_telegram }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)

    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.debug "Respuesta => [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end
