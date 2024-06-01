class ErrorAlPersistirUsuarioYaExistente < StandardError
  MSG_DE_ERROR = 'Error: usuario ya existente'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class CreadorDeUsuario
  def initialize(email, telegram_id)
    @email = email
    @telegram_id = telegram_id.to_i
  end

  def crear
    usuario = Usuario.new(@email, @telegram_id)
    raise ErrorAlPersistirUsuarioYaExistente if RepositorioUsuarios.new.save(usuario).nil?

    usuario
  rescue StandardError => _e
    raise
  end
end
