require 'integration_helper'
require_relative '../../dominio/pelicula'

describe Pelicula do
  subject(:pelicula) do
    anio_de_estreno = instance_double('AnioDeEstreno', anio: 2008)
    described_class.new('Iron Man', anio_de_estreno, 'accion')
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:titulo) }
    it { is_expected.to respond_to(:anio) }
    it { is_expected.to respond_to(:genero) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end
end
