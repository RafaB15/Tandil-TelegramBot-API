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
    usuarios.map { |u| respuesta << { email: u.email, telegram_id: u.telegram_id, id: u.id } }
    @estado = 200
    @respuesta = respuesta.to_json
  end

  def crear_usuario(creador_de_usuario)
    usuario = creador_de_usuario.crear

    @estado = 201
    @respuesta = { id: usuario.id, email: usuario.email, telegram_id: usuario.telegram_id }.to_json
  rescue ErrorAlPersistirUsuarioYaExistente => _e
    error_crear_usuario_con_parametro_existente(:telegram_id)
  rescue ErrorAlPersistirEmailYaExistente => _e
    error_crear_usuario_con_parametro_existente(:email)
  rescue ErrorAlInstanciarUsuarioEmailInvalido => _e
    @estado = 422
    @respuesta = {
      error: 'Entidad no procesable',
      message: 'La request se hizo bien, pero no se pudo completar por un error en la semantica del email.',
      details: [{ field: :email, message: 'Email invalido.' }]
    }.to_json
  rescue StandardError => _e
    error_inesperado
  end

  def crear_pelicula(creador_de_pelicula)
    pelicula = creador_de_pelicula.crear

    @estado = 201
    @respuesta = { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero }.to_json
  rescue ErrorAlInstanciarPeliculaAnioInvalido => _e
    @estado = 400
    @respuesta = { error: 'Solicitud Incorrecta', message: 'El parámetro requerido anio debe ser un año positivo.' }.to_json
  rescue ErrorAlInstanciarPeliculaTituloInvalido => _e
    @estado = 400
    @respuesta = { error: 'Solicitud Incorrecta', message: 'El parámetro requerido titulo debe ser un nombre.' }.to_json
  rescue ErrorAlInstanciarPeliculaGeneroInvalido => _e
    @estado = 400
    @respuesta = {
      error: 'Solicitud Incorrecta',
      message: 'El parámetro requerido \'genero\' debe ser un valor permitido.',
      details: {
        field: :genero,
        value: 'suspenso',
        allowed_values: %w[drama accion comedia],
        message: "El valor proporcionado para 'genero' debe ser uno de los siguientes: drama, accion, comedia."
      }
    }.to_json
  rescue StandardError => _e
    error_inesperado
  end

  def crear_visualizacion(creador_de_visualizacion)
    visualizacion = creador_de_visualizacion.crear

    @estado = 201
    @respuesta = { id: visualizacion.id, id_usuario: visualizacion.usuario.id, id_pelicula: visualizacion.pelicula.id, fecha: visualizacion.fecha.iso8601 }.to_json
  rescue StandardError => _e
    error_inesperado
  end

  def obtener_mas_vistos(visualizaciones)
    mas_vistos = contar_vistas_por_id(visualizaciones)
    nombres = nombres_por_id(visualizaciones)
    mas_vistos_trim = mas_vistos.sort_by { |_pelicula_id, count| -count }.first(3)
    mas_vistos_trim.map! { |pelicula_id, count| { id: pelicula_id, titulo: nombres[pelicula_id], vistas: count } }
    @estado = 200
    @respuesta = mas_vistos_trim.to_json
  end

  private

  def contar_vistas_por_id(visualizaciones)
    mas_vistos = Hash.new(0)
    visualizaciones.each do |v|
      mas_vistos[v.pelicula.id] += 1
    end
    mas_vistos
  end

  def nombres_por_id(visualizaciones)
    nombres = Hash.new(0)
    visualizaciones.each do |v|
      nombres[v.pelicula.id] = v.pelicula.titulo
    end
    nombres
  end

  def error_crear_usuario_con_parametro_existente(campo)
    parametros = {
      telegram_id: 'telegram ID',
      email: 'email'
    }

    @estado = 409
    @respuesta = {
      error: 'Conflicto',
      message: "El #{parametros[campo]} ya está asociado con una cuenta existente.",
      field: campo
    }.to_json
  end

  def error_inesperado
    @estado = 500
    @respuesta = {
      error: 'Error Interno del Servidor',
      message: 'Ocurrió un error inesperado en el servidor. Por favor, inténtelo de nuevo más tarde.'
    }.to_json
  end
end
