class ManejadorDeErrores
  ERROR_MAP = {
    'ErrorAlPersistirUsuarioYaExistente' => { estado: 409, campo: 'id_telegram', mensaje: 'Usuario ya existente' },
    'ErrorAlPersistirEmailYaExistente' => { estado: 409, campo: 'email', mensaje: 'Usuario ya existente' },
    'ErrorAlInstanciarUsuarioEmailInvalido' => { estado: 422, campo: 'email', mensaje: '' },
    'ErrorAlInstanciarUsuarioTelegramIDInvalido' => { estado: 422, campo: 'id_telegram', mensaje: '' },
    'ErrorAlInstanciarPeliculaAnioInvalido' => { estado: 400, campo: 'anio', mensaje: 'un año positivo' },
    'ErrorAlInstanciarPeliculaTituloInvalido' => { estado: 400, campo: 'titulo', mensaje: 'un nombre' },
    'ErrorAlInstanciarPeliculaGeneroInvalido' => { estado: 400, campo: 'genero', mensaje: 'drama, accion o comedia' },
    'ErrorAlPersistirPeliculaYaExistente' => { estado: 409, campo: 'titulo anio', mensaje: 'Ya existe una pelicula con el mismo titulo y año.' },
    'ErrorAlInstanciarCalificacionInvalida' => { estado: 422, campo: 'calificacion', mensaje: '' },
    'StandardError' => { estado: 500, campo: '', mensaje: '' }
  }.freeze

  def manejar_error(error)
    if ERROR_MAP.key?(error.class.name)
      ERROR_MAP[error.class.name]
    else
      { estado: 500, campo: '', mensaje: error.message }
    end
  end
end
