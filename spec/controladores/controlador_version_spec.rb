require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorVersion do
  let(:controlador_version) { described_class.new }

  describe 'enviar_version' do
    it 'debe devolver un json con la version y estado 200' do
      controlador_version.enviar_version('0.0.1')

      respuesta_json = JSON.parse(controlador_version.respuesta)

      expect(respuesta_json['version']).to eq '0.0.1'
      expect(controlador_version.estado).to eq 200
    end
  end
end
