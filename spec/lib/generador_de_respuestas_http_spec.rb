require 'integration_helper'
require_relative '../../lib/generador_de_respuestas_http'
require_relative '../../lib/creador_de_usuario'

describe GeneradorDeRespuestasHTTP do
  let(:generador_de_respuestas_http) { described_class.new }

  describe 'enviar_version' do
    it 'debe devolver un json con la version y estado 200' do
      generador_de_respuestas_http.enviar_version('0.0.1')

      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['version']).to eq '0.0.1'
      expect(generador_de_respuestas_http.estado).to eq 200
    end
  end

  describe 'crear_usuario' do
    let(:creador_usuario) { instance_double('CreadorUsuario') }

    it 'dado que el email y el telegram_id son validos se crea un usuario exitosamente con estado 201' do
      creador_usuario = CreadorDeUsuario.new('juan@gmail.com', 123_456_789)

      generador_de_respuestas_http.crear_usuario(creador_usuario)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['id'].to_i).to be > 0
      expect(generador_de_respuestas_http.estado).to eq 201
    end

    it 'dado que el email es invalido no se crea el usuario y se devuelve un estado 422' do
      allow(creador_usuario).to receive(:crear) { raise(ErrorAlInstanciarUsuarioEmailInvalido) }

      generador_de_respuestas_http.crear_usuario(creador_usuario)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['error']).to eq 'Entidad no procesable'
      expect(generador_de_respuestas_http.estado).to eq 422
    end

    it 'dado que ya existe un usuario con este telegram_id no se crea el usuario y se devuelve un estado 409' do
      allow(creador_usuario).to receive(:crear) { raise(ErrorAlPersistirUsuarioYaExistente) }

      generador_de_respuestas_http.crear_usuario(creador_usuario)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['error']).to eq 'Conflicto'
      expect(generador_de_respuestas_http.estado).to eq 409
    end
  end
end
