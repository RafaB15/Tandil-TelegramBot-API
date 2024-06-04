class ErrorAlInstanciarUsuarioTelegramIDInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: telegram ID invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class CreadorDeUsuario
  def initialize(email, telegram_id)
    @email = email
    @telegram_id = telegram_id
  end

  def crear
    raise ErrorAlInstanciarUsuarioTelegramIDInvalido unless es_el_telegram_id_valido?

    usuario = Usuario.new(@email, @telegram_id)
    RepositorioUsuarios.new.save(usuario)

    usuario
  rescue StandardError => _e
    raise
  end

  private

  def es_el_telegram_id_valido?
    !@telegram_id.nil? && @telegram_id >= 0
  end
end
