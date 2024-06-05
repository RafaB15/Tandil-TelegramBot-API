class ErrorAlInstanciarUsuarioEmailInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: email invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class Usuario
  attr_reader :email, :updated_on, :created_on, :id_telegram
  attr_accessor :id

  def initialize(email, id_telegram, id = nil)
    @email = es_el_email_valido?(email) ? email : raise(ErrorAlInstanciarUsuarioEmailInvalido)
    @id_telegram = id_telegram

    @id = id
  end

  private

  def es_el_email_valido?(email)
    email.match?(/\A[\w+-.]+@[a-z\d-]+(.[a-z]+)*.[a-z]+\z/i)
  end
end
