module PlataformaUsuarios
  def registrar_usuario(email, id_telegram, repositorio_usuarios)
    usuario = Usuario.new(email, id_telegram)
    usuario.usuario_existente?(repositorio_usuarios)
    repositorio_usuarios.save(usuario)
    usuario
  end
end
