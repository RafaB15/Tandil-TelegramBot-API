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
    @estado = 409
    @respuesta = {
      error: 'Conflicto',
      message: 'El telegram ID ya está asociado con una cuenta existente.',
      field: :telegram_id
    }.to_json
  rescue ErrorAlPersistirEmailYaExistente => _e
    @estado = 409
    @respuesta = {
      error: 'Conflicto',
      message: 'El email ya está asociado con una cuenta existente.',
      field: :email
    }.to_json
  rescue ErrorAlInstanciarUsuarioEmailInvalido => _e
    @estado = 422
    @respuesta = {
      error: 'Entidad no procesable',
      message: 'La request se hizo bien, pero no se pudo completar por un error en la semantica del email.',
      details: [
        {
          field: :email,
          message: 'Email invalido.'
        }
      ]
    }.to_json
  end

  def crear_pelicula(creador_de_pelicula)
    pelicula = creador_de_pelicula.crear

    @estado = 201
    @respuesta = { id: pelicula.id, titulo: pelicula.titulo, anio: pelicula.anio, genero: pelicula.genero }.to_json
  end

  def crear_visualizacion(creador_de_visualizacion)
    visualizacion = creador_de_visualizacion.crear

    @estado = 201
    @respuesta = { id: visualizacion.id, id_usuario: visualizacion.id_usuario, id_pelicula: visualizacion.id_pelicula, fecha: visualizacion.fecha }.to_json
  end
end
