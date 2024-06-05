require 'integration_helper'
Dir[File.join(__dir__, '../../lib', '*.rb')].each { |file| require_relative file }

describe CreadorDeUsuario do
  describe 'crear' do
    it 'debe levantar un error cuando id_telegram es nil' do
      expect { described_class.new('juan@gmail.com', nil).crear }.to raise_error(ErrorAlInstanciarUsuarioTelegramIDInvalido)
    end

    it 'debe levantar un error cuando id_telegram es menor a 0' do
      expect { described_class.new('juan@gmail.com', -1).crear }.to raise_error(ErrorAlInstanciarUsuarioTelegramIDInvalido)
    end
  end
end
