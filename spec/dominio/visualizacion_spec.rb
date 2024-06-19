require 'integration_helper'
require_relative '../../dominio/visualizacion'

describe Visualizacion do
  subject(:visualizacion) do
    usuario = instance_double('Usuario')
    pelicula = instance_double('Pelicula')
    fecha = instance_double('Time')

    described_class.new(usuario, pelicula, fecha)
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:contenido) }
    it { is_expected.to respond_to(:fecha) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end
end
