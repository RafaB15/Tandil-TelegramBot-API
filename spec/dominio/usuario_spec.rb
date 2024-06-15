require 'integration_helper'
require_relative '../../dominio/usuario'

describe Usuario do
  subject(:usuario) { described_class.new('email@gmail.com', 123_456_789) }

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:id_telegram) }
  end

  describe 'new' do
    it 'debe levantar un error cuando el email no es valido' do
      expect { described_class.new('gmail.com', 123_456_789) }.to raise_error(ErrorAlInstanciarUsuarioEmailInvalido)
    end

    it 'debe levantar un error cuando el id telegram no es valido' do
      expect { described_class.new('usuario@test.com', -123_456_789) }.to raise_error(ErrorAlInstanciarUsuarioTelegramIDInvalido)
    end
  end
end
