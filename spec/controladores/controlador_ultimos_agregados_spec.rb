require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorUltimosAgregados do
  let(:controlador_ultimos_agregados) { described_class.new }

  describe 'obtener_ultimos_agregados' do
    before(:each) do
      pelicula1 = CreadorDePelicula.new('Nahir', 2024, 'drama').crear
      pelicula2 = CreadorDePelicula.new('Amor', 2001, 'comedia').crear
      pelicula3 = CreadorDePelicula.new('Batman', 1998, 'accion').crear
    end

    xit 'dado que hay 3 contenidos recientemente agregados a la plataforma se ve una lista de los 3 contenidos' do
      controlador_ultimos_agregados.obtener_ultimos_agregados(RepositorioPeliculas.new.all)
      ultimos_agregados = JSON.parse(controlador_ultimos_agregados.respuesta)

      expect(ultimos_agregados.size).to eq 3
    end
  end
end
