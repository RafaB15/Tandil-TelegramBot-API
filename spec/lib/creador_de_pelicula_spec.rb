require 'integration_helper'
Dir[File.join(__dir__, '../../lib', '*.rb')].each { |file| require_relative file }

describe CreadorDePelicula do
  describe 'crear' do
    it 'debe levantar un error cuando anio es nil' do
      expect { described_class.new('John Wick 1', nil, 'accion').crear }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end

    it 'debe levantar un error cuando anio es menor a 0' do
      expect { described_class.new('John Wick 1', -1, 'accion').crear }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end

    it 'debe levantar un error cuando titulo es nil' do
      expect { described_class.new(nil, 2000, 'accion').crear }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end

    it 'debe levantar un error cuando titulo es un string vacio' do
      expect { described_class.new('', 2000, 'accion').crear }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end

    it 'debe levantar un error cuando genero es un valor inválido' do
      expect { described_class.new('John Wick 1', 2000, nil).crear }.to raise_error(ErrorAlInstanciarGeneroInvalido)
    end
  end
end
