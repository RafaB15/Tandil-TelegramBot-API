require 'integration_helper'
require_relative '../../dominio/pelicula'

describe Pelicula do
  subject(:pelicula) do
    described_class.new('Iron Man', 2008, 'accion')
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:titulo) }
    it { is_expected.to respond_to(:anio) }
    it { is_expected.to respond_to(:genero) }
    it { is_expected.to respond_to(:fecha_agregado) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end

  describe 'titulo invalido' do
    it 'raises an error' do
      expect { described_class.new('', 2008, 'accion') }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end
  end

  describe 'titulo invalido nil' do
    it 'raises an error' do
      expect { described_class.new('', nil, 'accion') }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end
  end

  describe 'anio invalido negativo' do
    it 'raises an error' do
      expect { described_class.new('Jumanji', -1, 'accion') }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end
  end

  describe 'anio invalido string' do
    it 'raises an error' do
      expect { described_class.new('Jumanji', 'dos mil uno', 'accion') }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end
  end

  describe 'pelicula existente' do
    it 'raises an error' do
      repositorio = instance_double('RepositorioPeliculas')
      allow(repositorio).to receive(:find_by_titulo_y_anio).and_return(true)
      expect { pelicula.contenido_existente?(repositorio) }.to raise_error(ErrorAlPersistirContenidoYaExistente)
    end
  end
end
