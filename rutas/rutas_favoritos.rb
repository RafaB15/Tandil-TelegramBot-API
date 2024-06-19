require 'sinatra'

require_relative './utiles'

post '/favoritos' do
  @body ||= request.body.read
  parametros_favoritos = JSON.parse(@body)
  id_telegram = parametros_favoritos['id_telegram']
  id_contenido = parametros_favoritos['id_contenido']

  settings.logger.debug "[POST] /favoritos - Iniciando creación de un nuevo contenido favorito - Body: #{parametros_favoritos}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_contenidos = RepositorioContenidos.new
  repositorio_favoritos = RepositorioFavoritos.new

  plataforma = Plataforma.new(id_telegram, id_contenido)

  begin
    favorito = plataforma.registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)

    estado = 201
    cuerpo = { id: favorito.id, id_telegram:, id_contenido: }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)

    estado = error_response.estado
    cuerpo = error_response.respuesta
  end

  settings.logger.debug "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end

get '/favoritos' do
  id_telegram = params['id_telegram']

  settings.logger.debug '[GET] /favoritos - Consultando los contenidos favoritos de un usuario'

  usuario = RepositorioUsuarios.new.find_by_id_telegram(id_telegram)

  favoritos = RepositorioFavoritos.new.find_by_user(usuario.id)

  estado = 200
  cuerpo = []

  favoritos.each do |favorito|
    cuerpo << { id: favorito.contenido.id, titulo: favorito.contenido.titulo, anio: favorito.contenido.anio, genero: favorito.contenido.genero }
  end

  settings.logger.debug "Respuesta : [Estado] : #{estado} - [Cuerpo] : #{cuerpo}"

  status estado
  cuerpo.to_json
end
