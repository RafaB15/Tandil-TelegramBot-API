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
end
