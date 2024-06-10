require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorFavorito do
  let(:controlador_favorito) { described_class.new }

  describe 'aniadir_favorito' do
    let(:creador_de_favorito) { instance_double('CreadorDeCalificacion') }
    let(:usuario) { instance_double('Usuario', id_telegram: 987_654_321, id: 1, email: 'test@gmail.com') }
    let(:pelicula) { instance_double('Pelicula', id: 2) }

    it 'dado un mail y un contenido, aniado ese contenido como favorito para el usuario con ese email' do
      allow(creador_de_favorito).to receive(:crear) { Favorito.new(usuario, pelicula, 42) }

      controlador_favorito.aniadir_favorito(creador_de_favorito)
      json_response = JSON.parse(controlador_favorito.respuesta)

      expect(controlador_favorito.estado).to eq 201
      expect(json_response['id']).to eq 42
    end
  end
end
