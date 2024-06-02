class CreadorDeUsuario
  def initialize(email, telegram_id)
    @email = email
    @telegram_id = telegram_id.to_i
  end

  def crear
    usuario = Usuario.new(@email, @telegram_id)
    RepositorioUsuarios.new.save(usuario)

    usuario
  rescue StandardError => _e
    raise
  end
end
