require 'integration_helper'
require_relative '../../dominio/calificacion'

describe Calificacion do
  subject(:calificacion) do
    usuario = instance_double('Usuario')
    pelicula = instance_double('Pelicula')

    described_class.new(usuario, pelicula, 5)
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:pelicula) }
    it { is_expected.to respond_to(:calificacion) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end
end
