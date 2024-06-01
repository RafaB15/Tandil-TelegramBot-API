class ErrorAlInstanciarUsuarioParametrosInvalidos < ArgumentError
  MSG_DE_ERROR = 'Error parametros invalidos'.freeze

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
    raise ErrorAlInstanciarUsuarioParametrosInvalidos unless are_paremeters_valid?

    @id = id
  end

  private

  def are_paremeters_valid?
    is_telegram_id_valid? && is_email_valid?
  end

  def is_telegram_id_valid?
    @telegram_id.is_a?(Integer)
  end

  def is_email_valid?
    @email.match?(/\A[\w+-.]+@[a-z\d-]+(.[a-z]+)*.[a-z]+\z/i)
  end
end
