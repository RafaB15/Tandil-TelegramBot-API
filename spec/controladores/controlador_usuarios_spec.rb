require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorUsuarios do
  let(:controlador_usuario) { described_class.new }

  describe 'crear_usuario' do
    let(:creador_de_usuario) { instance_double('CreadorDeUsuario') }

    it 'dado que el email y el id_telegram son validos se crea un usuario exitosamente con estado 201' do
      creador_de_usuario = CreadorDeUsuario.new('juan@gmail.com', 123_456_789)

      controlador_usuario.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(controlador_usuario.respuesta)

      expect(respuesta_json['id'].to_i).to be > 0
      expect(controlador_usuario.estado).to eq 201
    end

    it 'dado que el email es invalido no se crea el usuario y se devuelve un estado 422' do
      allow(creador_de_usuario).to receive(:crear) { raise(ErrorAlInstanciarUsuarioEmailInvalido) }

      controlador_usuario.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(controlador_usuario.respuesta)

      expect(respuesta_json['error']).to eq 'Entidad no procesable'
      expect(controlador_usuario.estado).to eq 422
    end

    it 'dado que ya existe un usuario con este id_telegram no se crea el usuario y se devuelve un estado 409' do
      allow(creador_de_usuario).to receive(:crear) { raise(ErrorAlPersistirUsuarioYaExistente) }

      controlador_usuario.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(controlador_usuario.respuesta)

      expect(respuesta_json).to include('error' => 'Conflicto', 'details' => { 'field' => 'id_telegram' })
      expect(controlador_usuario.estado).to eq 409
    end

    it 'dado que ya existe un usuario con este email no se crea el usuario y se devuelve un estado 409' do
      allow(creador_de_usuario).to receive(:crear) { raise(ErrorAlPersistirEmailYaExistente) }

      controlador_usuario.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(controlador_usuario.respuesta)

      expect(respuesta_json).to include('error' => 'Conflicto', 'details' => { 'field' => 'email' })
      expect(controlador_usuario.estado).to eq 409
    end
  end
end
