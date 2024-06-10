class ManejadorDeErrores
  ERROR_MAP_USUARIO = {
    'ErrorAlPersistirUsuarioYaExistente' => { estado: 409, campo: 'id_telegram', mensaje: 'Usuario ya existente' },
    'ErrorAlPersistirEmailYaExistente' => { estado: 409, campo: 'email', mensaje: 'Usuario ya existente' },
    'ErrorAlInstanciarUsuarioEmailInvalido' => { estado: 422, campo: 'email', mensaje: '' },
    'ErrorAlInstanciarUsuarioTelegramIDInvalido' => { estado: 422, campo: 'id_telegram', mensaje: '' },
    'StandardError' => { estado: 500, campo: '', mensaje: '' }
  }.freeze

  ERROR_MAP_PELICULA = {
    'ErrorAlInstanciarPeliculaAnioInvalido' => { estado: 400, campo: 'anio', mensaje: 'un año positivo' },
    'ErrorAlInstanciarPeliculaTituloInvalido' => { estado: 400, campo: 'titulo', mensaje: 'un nombre' },
    'ErrorAlInstanciarPeliculaGeneroInvalido' => { estado: 400, campo: 'genero', mensaje: 'drama, accion o comedia' },
    'ErrorAlPersistirPeliculaYaExistente' => { estado: 409, campo: 'titulo anio', mensaje: 'Ya existe una pelicula con el mismo titulo y año.' },
    'StandardError' => { estado: 500, campo: '', mensaje: '' }
  }.freeze

  def manejar_error(error)
    error_info = case error
                 when *ERROR_MAP_USUARIO.keys
                   ERROR_MAP_USUARIO[error.class.name] || ERROR_MAP_USUARIO['StandardError']
                 when *ERROR_MAP_PELICULA.keys
                   ERROR_MAP_PELICULA[error.class.name] || ERROR_MAP_PELICULA['StandardError']
                 else
                   { estado: 500, campo: '', mensaje: error.message }
                 end
    generar_respuesta_error(error_info[:estado], error_info[:campo], error_info[:mensaje])
  end

  private

  def generar_respuesta_error(estado, campo, mensaje)
    { estado:, campo:, mensaje: }.to_json
  end
end
