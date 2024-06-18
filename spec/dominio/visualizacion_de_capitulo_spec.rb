require 'integration_helper'
require_relative '../../dominio/visualizacion_de_capitulo'

describe VisualizacionDeCapitulo do
  subject(:visualizacion) do
    usuario = instance_double('Usuario')
    temporada_de_serie = instance_double('TemporadaDeSerie')
    fecha = instance_double('Time')
    numero_capitulo = 1

    described_class.new(usuario, temporada_de_serie, fecha, numero_capitulo)
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:temporada_de_serie) }
    it { is_expected.to respond_to(:fecha) }
    it { is_expected.to respond_to(:numero_capitulo) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end
end
