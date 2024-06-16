class ErrorAlInstanciarUsuarioEmailInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: email invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorAlInstanciarUsuarioTelegramIDInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: telegram ID invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class Usuario
  attr_reader :email, :updated_on, :created_on, :id_telegram
  attr_accessor :id

  def initialize(email, id_telegram, id = nil)
    @email = es_el_email_valido?(email) ? email : raise(ErrorAlInstanciarUsuarioEmailInvalido)
    @id_telegram = es_el_id_telegram_valido?(id_telegram) ? id_telegram : raise(ErrorAlInstanciarUsuarioTelegramIDInvalido)

    @id = id
  end

  def usuario_existente?(repositorio_usuarios)
    raise ErrorAlPersistirUsuarioYaExistente if repositorio_usuarios.find_by_id_telegram(@id_telegram)
    raise ErrorAlPersistirEmailYaExistente if repositorio_usuarios.find_by_email(@email)
  end

  private

  def es_el_email_valido?(email)
    email.match?(/\A[\w+-.]+@[a-z\d-]+(.[a-z]+)*.[a-z]+\z/i)
  end

  def es_el_id_telegram_valido?(id_telegram)
    !id_telegram.nil? && id_telegram >= 0
  end
end
