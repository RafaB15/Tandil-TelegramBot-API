require_relative './utiles'

post '/favoritos' do
  @body ||= request.body.read
  parametros_favoritos = JSON.parse(@body)
  id_telegram = parametros_favoritos['id_telegram']
  id_contenido = parametros_favoritos['id_contenido']

  settings.logger.info "[POST] /favoritos - Iniciando creación de un nuevo contenido favorito - Body: #{parametros_favoritos}"

  repositorio_usuarios = RepositorioUsuarios.new
  repositorio_peliculas = RepositorioContenidos.new
  repositorio_favoritos = RepositorioFavoritos.new

  plataforma = Plataforma.new(id_telegram, id_contenido)

  begin
    favorito = plataforma.registrar_favorito(repositorio_usuarios, repositorio_peliculas, repositorio_favoritos)
    estado = 201
    respuesta = { id: favorito.id, id_telegram:, id_contenido: }
  rescue StandardError => e
    mapeo_error_http = ManejadorDeErrores.new(e)
    error_response = GeneradorDeErroresHTTP.new(mapeo_error_http)
    estado = error_response.estado
    respuesta = error_response.respuesta
  end

  settings.logger.info "[Status] : #{estado} - [Response] : #{respuesta}"
  enviar_respuesta(estado, respuesta)
end

get '/favoritos' do
  id_telegram = params['id_telegram']
  usuario = RepositorioUsuarios.new.find_by_id_telegram(id_telegram)

  favoritos = RepositorioFavoritos.new.find_by_user(usuario.id)

  status 200
  response = []

  favoritos.each do |favorito|
    response << { id: favorito.contenido.id, titulo: favorito.contenido.titulo, anio: favorito.contenido.anio, genero: favorito.contenido.genero }
  end

  response.to_json
end
