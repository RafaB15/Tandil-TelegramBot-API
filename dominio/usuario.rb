class Usuario
  attr_reader :email, :updated_on, :created_on
  attr_accessor :id

  def initialize(email, id = nil)
    @email = email
    @id = id
  end
end
