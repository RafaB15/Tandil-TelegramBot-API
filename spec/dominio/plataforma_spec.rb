require 'rspec'
require_relative '../../dominio/plataforma'

describe 'Plataforma' do
  describe 'registrar_favorito' do
    let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:repositorio_favoritos) { instance_double('RepositorioFavoritos') }
    let(:usuario) { instance_double('Usuario') }
    let(:pelicula) { instance_double('Pelicula') }
    let(:favorito) { instance_double('Favorito') }
    let(:plataforma) { Plataforma.new(123, 456) }

    before(:each) do
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(usuario)
      allow(repositorio_contenidos).to receive(:find).and_return(pelicula)
      allow(repositorio_favoritos).to receive(:save)
      allow(Favorito).to receive(:new).and_return(favorito)
    end

    it 'deberia crear y guardar un nuevo favorito' do
      expect(Favorito).to receive(:new).with(usuario, pelicula)
      expect(repositorio_favoritos).to receive(:save).with(favorito)

      result = plataforma.registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)

      expect(result).to eq(favorito)
    end
  end

  describe 'registrar_calificacion' do
    let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:repositorio_visualizaciones) { instance_double('RepositorioVisualizaciones') }
    let(:repositorio_calificaciones) { instance_double('RepositorioCalificaciones') }
    let(:usuario) { instance_double('Usuario', id: 1) }
    let(:pelicula) { instance_double('Pelicula') }
    let(:visualizacion) { instance_double('Visualizacion') }
    let(:calificacion) { instance_double('Calificacion') }
    let(:plataforma) { Plataforma.new(123, 456) }

    before(:each) do
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(usuario)
      allow(repositorio_contenidos).to receive(:find).and_return(pelicula)
      allow(repositorio_visualizaciones).to receive(:find_by_usuario_y_contenido).and_return(visualizacion)
      allow(Calificacion).to receive(:new).and_return(calificacion)
      allow(repositorio_calificaciones).to receive(:save)
    end

    it 'debería crear y guardar una nueva calificación' do
      expect(Calificacion).to receive(:new).with(usuario, pelicula, 5)
      expect(repositorio_calificaciones).to receive(:save).with(calificacion)

      result = plataforma.registrar_calificacion(5, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)

      expect(result).to eq(calificacion)
    end

    it 'debería lanzar un error si el contenido no existe' do
      allow(repositorio_contenidos).to receive(:find).and_raise(NameError)

      expect { plataforma.registrar_calificacion(5, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones) }.to raise_error(ErrorPeliculaInexistente)
    end

    it 'debería lanzar un error si la visualizacion no existe' do
      allow(repositorio_visualizaciones).to receive(:find_by_usuario_y_contenido).and_return(nil)

      expect do
        plataforma.registrar_calificacion(5, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
      end.to raise_error(ErrorVisualizacionInexistente)
    end
  end
end
