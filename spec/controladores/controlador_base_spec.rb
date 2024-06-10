require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorBase do
  let(:controlador_base) { described_class.new }

  describe 'generar_respuesta' do
    it 'debe devolver un json con el estado y data' do
      controlador_base.generar_respuesta(200, 'data')

      respuesta_json = JSON.parse(controlador_base.respuesta)

      expect(respuesta_json).to eq 'data'
      expect(controlador_base.estado).to eq 200
    end
  end

  describe 'generar_respuesta_error' do
    it 'debe devolver un json con el estado y mensaje de error' do
      controlador_base.generar_respuesta_error(409, 'campo_test', 'mensaje_test')

      respuesta_json = JSON.parse(controlador_base.respuesta)

      expect(respuesta_json).to eq({ 'details' => { 'field' => 'campo_test' }, 'error' => 'Conflicto', 'message' => 'mensaje_test' })
      expect(controlador_base.estado).to eq 409
      expect(controlador_base.respuesta).to eq '{"error":"Conflicto","message":"mensaje_test","details":{"field":"campo_test"}}'
    end
  end
end
