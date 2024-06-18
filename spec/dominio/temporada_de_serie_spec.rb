require 'integration_helper'
require_relative '../../dominio/temporada_de_serie'

describe TemporadaDeSerie do
  subject(:serie) do
    described_class.new('Iron Man', 2008, 'accion', Date.today, 3)
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:titulo) }
    it { is_expected.to respond_to(:anio) }
    it { is_expected.to respond_to(:genero) }
    it { is_expected.to respond_to(:fecha_agregado) }
    it { is_expected.to respond_to(:cantidad_capitulos) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end

  describe 'titulo invalido' do
    it 'raises an error' do
      expect { described_class.new('', 2008, 'accion', 'serie', 12) }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end
  end

  describe 'titulo invalido nil' do
    it 'raises an error' do
      expect { described_class.new('', nil, 'accion', 'serie', 32) }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end
  end

  describe 'anio invalido string' do
    it 'raises an error' do
      expect { described_class.new('Amor - Temporada 2', 'dos mil uno', 'accion', 'serie', 3) }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end
  end

  describe 'anio invalido negativo' do
    it 'raises an error' do
      expect { described_class.new('Amor - Temporada 1', -1, 'accion', 'serie', 21) }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end
  end

  describe 'serie existente' do
    it 'raises an error' do
      repositorio = instance_double('RepositorioContenidos')
      allow(repositorio).to receive(:find_by_titulo_y_anio).and_return(true)
      expect { serie.contenido_existente?(repositorio) }.to raise_error(ErrorAlPersistirContenidoYaExistente)
    end
  end
end