require 'integration_helper'
require_relative '../../dominio/usuario'
require_relative '../../persistencia/repositorio_usuarios'

describe RepositorioUsuarios do
  it 'deberia guardar y asignar id si el usuario es nuevo' do
    juan = Usuario.new('juan@test.com', 123_456_789)
    described_class.new.save(juan)
    expect(juan.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_usuarios_iniciales = repositorio.all.size
    juan = Usuario.new('juan@test.com', 123_456_789)
    repositorio.save(juan)
    expect(repositorio.all.size).to be(cantidad_de_usuarios_iniciales + 1)
  end

  it 'guardar un usuario con el mismo telegram ID dos veces me da un error' do
    repositorio = described_class.new
    juan = Usuario.new('jaun@test.com', 123_345_789)
    repositorio.save(juan)

    juanchi = Usuario.new('jaunchi@test.com', 123_345_789)
    expect(repositorio.save(juanchi)).to be_nil
  end
end
