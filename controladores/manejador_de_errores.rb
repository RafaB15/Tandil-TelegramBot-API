class ManejadorDeErrores
  attr_reader :estado, :campo, :mensaje

  def initialize(error)
    respuesta = manejar_error(error)
    @estado = respuesta[:estado]
    @campo = respuesta[:campo]
    @mensaje = respuesta[:mensaje]
  end

  ERROR_MAP = {
    'ErrorAlPersistirUsuarioYaExistente' => { estado: 409, campo: 'id_telegram', mensaje: 'Usuario ya existente' },
    'ErrorAlPersistirEmailYaExistente' => { estado: 409, campo: 'email', mensaje: 'Usuario ya existente' },
    'ErrorAlInstanciarUsuarioEmailInvalido' => { estado: 422, campo: 'email', mensaje: '' },
    'ErrorAlInstanciarUsuarioTelegramIDInvalido' => { estado: 422, campo: 'id_telegram', mensaje: '' },
    'ErrorAlInstanciarAnioInvalido' => { estado: 400, campo: 'anio', mensaje: 'un año positivo' },
    'ErrorAlInstanciarTituloInvalido' => { estado: 400, campo: 'titulo', mensaje: 'un nombre' },
    'ErrorAlInstanciarGeneroInvalido' => { estado: 400, campo: 'genero', mensaje: 'drama, accion o comedia' },
    'ErrorAlInstanciarCantidadDeCapitulosInvalido' => { estado: 400, campo: 'cantidad de capitulos', mensaje: 'positivo.' },
    'ErrorAlInstanciarTipoInvalido' => { estado: 400, campo: 'tipo', mensaje: 'pelicula o serie' },
    'ErrorAlPersistirContenidoYaExistente' => { estado: 409, campo: 'titulo anio', mensaje: 'Ya existe un contenido con el mismo titulo y año.' },
    'ErrorAlInstanciarCalificacionInvalida' => { estado: 422, campo: 'calificacion', mensaje: '' },
    'ErrorContenidoInexistente' => { estado: 404, campo: 'contenido', mensaje: '' },
    'ErrorVisualizacionInexistente' => { estado: 422, campo: 'visualizacion', mensaje: '' },
    'ErrorContenidoInexistenteEnLaAPIDeOMDb' => { estado: 404, campo: 'omdb', mensaje: '' },
    'ErrorTemporadaSinSuficientesCapitulosVistos' => { estado: 422, campo: 'visualizacion_de_capitulo', mensaje: 'Es necesario ver mas capitulos' },
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
