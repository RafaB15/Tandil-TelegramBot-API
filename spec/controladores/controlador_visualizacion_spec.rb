require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorVisualizacion do
  let(:controlador_visualizacion) { described_class.new }
  let(:creador_de_visualizacion) { instance_double('CreadorDeVisualizacion') }

  describe 'crear_visualizacion' do
    let(:creador_de_visualizacion) { instance_double('CreadorDeVisualizacion') }
    let(:usuario) { instance_double('Usuario', email: 'juan@gmail.com', id: 1) }
    let(:pelicula) { instance_double('Pelicula', id: 2) }

    it 'dado que el id_pelicula, id_usuario y fecha son válidos se crea una visualización exitosamente con estado 201' do
      allow(creador_de_visualizacion).to receive(:crear) { Visualizacion.new(usuario, pelicula, Time.iso8601('2024-06-02T23:34:40+0000'), 10) }

      controlador_visualizacion.crear_visualizacion(creador_de_visualizacion)
      respuesta_json = JSON.parse(controlador_visualizacion.respuesta)

      expect(respuesta_json['id'].to_i).to eq 10
      expect(controlador_visualizacion.estado).to eq 201
    end
  end
end
