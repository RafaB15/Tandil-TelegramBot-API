# require_relative '../dominio/usuarios'
require 'sinatra'

class GeneradorDeRespuestasHTTP
  attr_reader :estado, :respuesta

  def initialize
    @estado = 0
    @respuesta = nil
  end

  def enviar_version(version)
    @estado = 200
    @respuesta = { version: }.to_json
  end

  def reiniciar_usuarios
    @estado = 200
  end

  def enviar_usuarios(usuarios)
    respuesta = []
    usuarios.map { |u| respuesta << { email: u.email, id_telegram: u.id_telegram, id: u.id } }
    @estado = 200
    @respuesta = respuesta.to_json
  end

  def crear_usuario(creador_de_usuario)
    usuario = creador_de_usuario.crear
    generar_respuesta(201, { id: usuario.id, email: usuario.email, id_telegram: usuario.id_telegram })
  rescue StandardError => e
    manejar_error_usuario(e)
  end

  def crear_pelicula(creador_de_pelicula)
    pelicula = creador_de_pelicula.crear
    generar_respuesta(201, { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero })
  rescue StandardError => e
    manejar_error_pelicula(e)
  end

  def crear_visualizacion(creador_de_visualizacion)
    visualizacion = creador_de_visualizacion.crear
    @estado = 201
    @respuesta = { id: visualizacion.id, email: visualizacion.usuario.email, id_pelicula: visualizacion.pelicula.id, fecha: visualizacion.fecha.iso8601 }.to_json
  rescue StandardError => e
    @estado = 500
    @respuesta = GeneradorDeRespuestasDeErroresHTTP.new(@estado, '', e.message).respuesta
  end

  def crear_calificacion(creador_de_calificacion)
    calificacion = creador_de_calificacion.crear
    @estado = 201
    @respuesta = { id: calificacion.id, id_telegram: calificacion.usuario.id_telegram, id_pelicula: calificacion.pelicula.id, calificacion: calificacion.calificacion }.to_json
  rescue StandardError => e
    @estado = 500
    @respuesta = GeneradorDeRespuestasDeErroresHTTP.new(@estado, '', e.message).respuesta
  end

  def obtener_mas_vistos(visualizaciones)
    mas_vistos = ContadorDeVistas.new(visualizaciones).obtener_mas_vistos

    @estado = 200
    @respuesta = mas_vistos.to_json
  rescue StandardError => e
    @estado = 500
    @respuesta = GeneradorDeRespuestasDeErroresHTTP.new(@estado, '', e.message).respuesta
  end

  def aniadir_favorito(creador_de_favorito)
    favorito = creador_de_favorito.crear
    @estado = 201
    @respuesta = { id: favorito.id, id_telegram: favorito.usuario.id_telegram, id_contenido: favorito.contenido.id }.to_json
  rescue StandardError => e
    @estado = 500
    @respuesta = GeneradorDeRespuestasDeErroresHTTP.new(@estado, '', e.message).respuesta
  end

  private

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

  def manejar_error_usuario(error)
    error_key = error.class.name.split('::').last
    error_info = ERROR_MAP_USUARIO[error_key] || ERROR_MAP_USUARIO['StandardError']
    generar_respuesta_error(error_info[:estado], error_info[:campo], error_info[:mensaje])
  end

  def manejar_error_pelicula(error)
    error_key = error.class.name.split('::').last
    error_info = ERROR_MAP_PELICULA[error_key] || ERROR_MAP_PELICULA['StandardError']
    generar_respuesta_error(error_info[:estado], error_info[:campo], error_info[:mensaje])
  end

  def generar_respuesta(estado, data)
    @estado = estado
    @respuesta = data.to_json
  end

  def generar_respuesta_error(estado, campo = '', mensaje = '')
    error_response = GeneradorDeRespuestasDeErroresHTTP.new(estado, campo, mensaje)

    @estado = error_response.estado
    @respuesta = error_response.respuesta
  end
end
