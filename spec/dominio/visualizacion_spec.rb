require 'integration_helper'
require_relative '../../dominio/visualizacion'

describe Visualizacion do
  subject(:visualizacion) { described_class.new(10, 20, '2024-06-02T14:00:00Z') }

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:id_usuario) }
    it { is_expected.to respond_to(:id_pelicula) }
    it { is_expected.to respond_to(:fecha) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end
end
