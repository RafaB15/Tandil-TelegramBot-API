require 'integration_helper'
require_relative '../../dominio/visualizacion'

describe Visualizacion do
  subject(:visualizacion) do
    usuario = instance_double('Usuario')
    pelicula = instance_double('Pelicula')

    described_class.new(usuario, pelicula, '2024-06-02T14:00:00Z')
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:pelicula) }
    it { is_expected.to respond_to(:fecha) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end
end
