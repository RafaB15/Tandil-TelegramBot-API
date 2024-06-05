class ErrorAlInstanciarUsuarioTelegramIDInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: telegram ID invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class CreadorDeUsuario
  def initialize(email, id_telegram)
    @email = email
    @id_telegram = id_telegram
  end

  def crear
    raise ErrorAlInstanciarUsuarioTelegramIDInvalido unless es_el_id_telegram_valido?

    usuario = Usuario.new(@email, @id_telegram)
    RepositorioUsuarios.new.save(usuario)

    usuario
  rescue StandardError => _e
    raise
  end

  private

  def es_el_id_telegram_valido?
    !@id_telegram.nil? && @id_telegram >= 0
  end
end
