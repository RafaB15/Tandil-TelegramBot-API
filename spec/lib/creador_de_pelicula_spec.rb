require 'integration_helper'
Dir[File.join(__dir__, '../../lib', '*.rb')].each { |file| require_relative file }

describe CreadorDePelicula do
  describe 'crear' do
    it 'debe levantar un error cuando anio es nil' do
      expect { described_class.new('John Wick 1', nil, 'accion').crear }.to raise_error(ErrorAlInstanciarPeliculaAnioInvalido)
    end

    it 'debe levantar un error cuando anio es menor a 0' do
      expect { described_class.new('John Wick 1', -1, 'accion').crear }.to raise_error(ErrorAlInstanciarPeliculaAnioInvalido)
    end
  end
end
