require 'integration_helper'
Dir[File.join(__dir__, '../../lib', '*.rb')].each { |file| require_relative file }

describe CreadorDeVisualizacion do
  let(:creador_de_visualizacion) do
    id_usuario = CreadorDeUsuario.new('nico_paez@gmail.com', 123_456_789).crear.id
    id_pelicula = CreadorDePelicula.new('Nair', 2024, 'Drama').crear.id
    described_class.new(id_usuario, id_pelicula, '2024-06-02T21:34:40+0000')
  end

  describe 'crear' do
    it 'dado que el id_usuario, id_pelicula y fecha son válidos se crea y se guarda una visualización' do
      visualizacion = creador_de_visualizacion.crear

      expect(visualizacion.id).to be > 0
      expect(visualizacion.fecha).to eq Time.iso8601('2024-06-02T21:34:40+0000')
    end
  end
end
