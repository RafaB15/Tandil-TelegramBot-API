require_relative './abstract_repository'

class ErrorAlPersistirUsuarioYaExistente < StandardError
  MSG_DE_ERROR = 'Error: usuario ya existente'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorAlPersistirEmailYaExistente < StandardError
  MSG_DE_ERROR = 'Error: email ya existente'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class RepositorioUsuarios < AbstractRepository
  self.table_name = :usuarios
  self.model_class = 'Usuario'

  def save(a_record)
    raise ErrorAlPersistirUsuarioYaExistente if find_by_telegram_id(a_record.telegram_id)
    raise ErrorAlPersistirEmailYaExistente if find_by_email(a_record.email)

    super(a_record)
  end

  def find_by_telegram_id(telegram_id)
    row = dataset.first(telegram_id:)
    load_object(row) unless row.nil?
  end

  def find_by_email(email)
    row = dataset.first(email:)
    load_object(row) unless row.nil?
  end

  protected

  def load_object(a_hash)
    Usuario.new(a_hash[:email], a_hash[:telegram_id], a_hash[:id])
  end

  def changeset(usuario)
    {
      email: usuario.email,
      telegram_id: usuario.telegram_id
    }
  end
end
