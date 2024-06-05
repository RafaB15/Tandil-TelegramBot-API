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
  rescue StandardError => _e
    @estado = 500
    @respuesta = GeneradorDeRespuestasDeErroresHTTP.new(@estado)
  end

  def obtener_mas_vistos(visualizaciones)
    mas_vistos = contar_vistas_por_id(visualizaciones)
    nombres = nombres_por_id(visualizaciones)
    mas_vistos_nombre = mas_vistos.map { |pelicula_id, count| { id: pelicula_id, titulo: nombres[pelicula_id], vistas: count } }
    mas_vistos_trim = mas_vistos_nombre.sort_by { |c| [-c[:vistas], c[:titulo]] }.first(3)

    @estado = 200
    @respuesta = mas_vistos_trim.to_json
  rescue StandardError => _e
    error_inesperado
  end

  private

  ERROR_MAP_USUARIO = {
    'ErrorAlPersistirUsuarioYaExistente' => { estado: 409, campo: 'id_telegram', mensaje: 'Usuario ya existente' },
    'ErrorAlPersistirEmailYaExistente' => { estado: 409, campo: 'email', mensaje: 'Usuario ya existente' },
    'ErrorAlInstanciarUsuarioEmailInvalido' => { estado: 422, campo: 'email', mensaje: '' },
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

  def contar_vistas_por_id(visualizaciones)
    visualizaciones.each_with_object(Hash.new(0)) do |v, mas_vistos|
      mas_vistos[v.pelicula.id] += 1
    end
  end

  def nombres_por_id(visualizaciones)
    visualizaciones.each_with_object({}) do |v, nombres|
      nombres[v.pelicula.id] = v.pelicula.titulo
    end
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
