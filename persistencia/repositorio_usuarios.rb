require_relative './abstract_repository'

class RepositorioUsuarios < AbstractRepository
  self.table_name = :usuarios
  self.model_class = 'Usuario'

  def find_by_id_telegram(id_telegram)
    row = dataset.first(id_telegram:)
    load_object(row) unless row.nil?
  end

  def find_by_email(email)
    row = dataset.first(email:)
    load_object(row) unless row.nil?
  end

  protected

  def load_object(a_hash)
    Usuario.new(a_hash[:email], a_hash[:id_telegram], a_hash[:id])
  end

  def changeset(usuario)
    {
      email: usuario.email,
      id_telegram: usuario.id_telegram
    }
  end
end
