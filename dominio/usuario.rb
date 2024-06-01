class ErrorAlInstanciarUsuarioEmailInvalido < ArgumentError
  MSG_DE_ERROR = 'Error email invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorAlInstanciarUsuarioTelegramIDInvalido < ArgumentError
  MSG_DE_ERROR = 'Error telegram ID invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class Usuario
  attr_reader :email, :updated_on, :created_on, :telegram_id
  attr_accessor :id

  def initialize(email, telegram_id, id = nil)
    @email = email
    @telegram_id = telegram_id
    begin
      son_los_parametros_validos?
    rescue StandardError => _e
      raise
    end

    @id = id
  end

  private

  def son_los_parametros_validos?
    raise ErrorAlInstanciarUsuarioTelegramIDInvalido unless es_el_telegram_id_valido?
    raise ErrorAlInstanciarUsuarioEmailInvalido unless es_email_valido?
  end

  def es_el_telegram_id_valido?
    @telegram_id.is_a?(Integer)
  end

  def es_email_valido?
    @email.match?(/\A[\w+-.]+@[a-z\d-]+(.[a-z]+)*.[a-z]+\z/i)
  end
end
