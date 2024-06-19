require 'integration_helper'
require_relative '../../dominio/temporada_de_serie'

describe TemporadaDeSerie do
  subject(:serie) do
    described_class.new('Iron Man - Temporada 1', 2008, 'accion', 3, Date.today)
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
      expect { described_class.new('', 2008, 'accion', 12, Date.today) }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end
  end

  describe 'titulo invalido nil' do
    it 'raises an error' do
      expect { described_class.new(nil, 2008, 'accion', 32, Date.today) }.to raise_error(ErrorAlInstanciarTituloInvalido)
    end
  end

  describe 'anio invalido string' do
    it 'raises an error' do
      expect { described_class.new('Amor - Temporada 2', 'dos mil uno', 'accion', 3, Date.today) }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end
  end

  describe 'anio invalido negativo' do
    it 'raises an error' do
      expect { described_class.new('Amor - Temporada 1', -1, 'accion', 21, Date.today) }.to raise_error(ErrorAlInstanciarAnioInvalido)
    end
  end

  describe 'serie existente' do
    it 'raises an error' do
      repositorio = instance_double('RepositorioContenidos')
      allow(repositorio).to receive(:find_by_titulo_y_anio).and_return(true)
      expect { serie.contenido_existente?(repositorio) }.to raise_error(ErrorAlPersistirContenidoYaExistente)
    end
  end

  describe 'titulo de serie' do
    it 'si le pido el titulo de serie, solo debe devolver el titulo, no la temporada' do
      temporada_de_serie = described_class.new('Friends - Temporada 1', 2008, 'accion', 12, Date.today)

      expect(temporada_de_serie.titulo_de_serie).to eq 'Friends'
    end
  end

  describe 'cantidad de capitulos invalido' do
    it 'raises an error' do
      expect { described_class.new('Amor - Temporada 1', 2001, 'comedia', nil, Date.today) }.to raise_error(ErrorAlInstanciarCantidadDeCapitulosInvalido)
    end
  end

  describe 'cantidad de capitulos invalido negativo' do
    it 'raises an error' do
      expect { described_class.new('Amor - Temporada 1', 2001, 'comedia', -1, Date.today) }.to raise_error(ErrorAlInstanciarCantidadDeCapitulosInvalido)
    end
  end
end
