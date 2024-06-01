require_relative './abstract_repository'

class RepositorioUsuarios < AbstractRepository
  self.table_name = :usuarios
  self.model_class = 'Usuario'

  def save(a_record)
    super(a_record) unless find_by_telegram_id(a_record.telegram_id)
  end

  def find_by_telegram_id(telegram_id)
    row = dataset.first(telegram_id:)
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
