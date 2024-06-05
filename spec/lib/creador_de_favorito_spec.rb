require 'integration_helper'
Dir[File.join(__dir__, '../../lib', '*.rb')].each { |file| require_relative file }

describe CreadorDefavorito do
  let(:email) { CreadorDeUsuario.new('nico_paez@gmail.com', 123_456_789).crear.email }
  let(:id_contenido) { CreadorDePelicula.new('Nair', 2024, 'drama').crear.id }
  let(:creador_de_favorito) { described_class.new(email, id_contenido) }

  describe 'crear' do
    it 'dado que el usuario y la pelicula son válidos se crea y se guarda un favorito' do
      favorito = creador_de_favorito.crear

      expect(favorito.id).to be > 0
      expect(favorito.usuario.email).to eq email
      expect(favorito.contenido.id).to eq id_contenido
    end
  end
end
