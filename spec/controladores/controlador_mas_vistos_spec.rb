require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorMasVistos do
  let(:controlador_mas_vistos) { described_class.new }

  describe 'obtener_mas_vistos' do
    before(:each) do
      email = CreadorDeUsuario.new('test@mail.com', 123_456_789).crear.email
      pelicula1 = CreadorDePelicula.new('Nahir', 2024, 'drama').crear
      pelicula2 = CreadorDePelicula.new('Amor', 2001, 'comedia').crear
      pelicula3 = CreadorDePelicula.new('Batman', 1998, 'accion').crear
      CreadorDeVisualizacion.new(email, pelicula1.id, Time.now.iso8601).crear
      CreadorDeVisualizacion.new(email, pelicula2.id, Time.now.iso8601).crear
      CreadorDeVisualizacion.new(email, pelicula3.id, Time.now.iso8601).crear
    end

    it 'dado que hay 3 contenidos vistos en la plataforma se ve una lista de los 3 contenidos mas vistos' do
      controlador_mas_vistos.obtener_mas_vistos(RepositorioVisualizaciones.new.all)
      mas_vistos = JSON.parse(controlador_mas_vistos.respuesta)

      expect(mas_vistos.size).to eq 3
    end
  end
end
