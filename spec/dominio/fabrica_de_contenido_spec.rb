require 'rspec'
require_relative '../../dominio/fabrica_de_contenido'
require_relative '../../dominio/pelicula'
require_relative '../../dominio/serie'
require_relative '../../dominio/contenido'
require_relative '../../lib/genero'

RSpec.describe FabricaDeContenido do
  describe 'crear_contenido' do
    let(:genero) { instance_double('Genero') }

    it 'crea un nuevo contenido de tipo Pelicula' do
      contenido = described_class.crear_contenido('Las chicas superpoderosas', 2009, genero, Date.today)
      expect(contenido).to be_a(Pelicula)
    end

    it 'crea un nuevo contenido de tipo Serie' do
      contenido = described_class.crear_contenido('Las chicas superpoderosas', 2009, genero, Date.today, 12)
      expect(contenido).to be_a(Serie)
    end
  end
end
