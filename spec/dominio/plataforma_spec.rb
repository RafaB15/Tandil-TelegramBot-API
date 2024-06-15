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
      allow(repositorio_visualizaciones).to receive(:find_by_id_usuario_y_id_contenido).and_return(visualizacion)
      allow(Calificacion).to receive(:new).and_return(calificacion)
      allow(repositorio_calificaciones).to receive(:save)
    end

    it 'dado que el id_telegram, id_pelicula y calificacion son válidos se crea una calificacion' do
      expect(Calificacion).to receive(:new).with(usuario, pelicula, 5)
      expect(repositorio_calificaciones).to receive(:save).with(calificacion)
      puntaje = 5

      result = plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)

      expect(result).to eq(calificacion)
    end

    it 'debería lanzar un error si el contenido no existe' do
      allow(repositorio_contenidos).to receive(:find).and_raise(NameError)
      puntaje = 5

      expect do
        plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
      end.to raise_error(ErrorPeliculaInexistente)
    end

    it 'debería lanzar un error si la visualizacion no existe' do
      allow(repositorio_visualizaciones).to receive(:find_by_id_usuario_y_id_contenido).and_return(nil)
      puntaje = 5

      expect do
        plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)
      end.to raise_error(ErrorVisualizacionInexistente)
    end
  end

  describe 'registrar_usuario' do
    let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
    let(:usuario) { instance_double('Usuario') }
    let(:plataforma) { Plataforma.new(123, 456) }

    before(:each) do
      allow(Usuario).to receive(:new).and_return(usuario)
      allow(repositorio_usuarios).to receive(:save)
    end

    it 'debería crear y guardar un nuevo usuario' do
      expect(Usuario).to receive(:new).with('usuario@test.com', 123)
      expect(repositorio_usuarios).to receive(:save).with(usuario)

      result = plataforma.registrar_usuario('usuario@test.com', 123, repositorio_usuarios)
      expect(result).to eq(usuario)
    end
  end

  describe 'registrar_contenido' do
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:genero) { instance_double('Genero') }
    let(:anio) { instance_double('AnioDeEstreno') }
    let(:pelicula) { instance_double('Pelicula') }
    let(:plataforma) { Plataforma.new(123, 456) }
    let(:fecha_agregado) { Date.new(2023, 4, 1) }

    before(:each) do
      allow(Genero).to receive(:new).with('accion').and_return(genero)
      allow(AnioDeEstreno).to receive(:new).with(2008).and_return(anio)
      allow(Pelicula).to receive(:new).with('Iron Man', anio, genero, fecha_agregado).and_return(pelicula)
      allow(repositorio_contenidos).to receive(:save).with(pelicula).and_return(pelicula)
    end

    it 'dado que el titulo, anio y genero son válidos se crea una película exitosamente con estado 201' do
      result = plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, fecha_agregado)
      expect(result).to eq(pelicula)
    end

    it 'dado que el anio es inválido no se crea una película y se levanta el error correspondiente' do
      allow(AnioDeEstreno).to receive(:new).with(nil).and_raise(ErrorAlInstanciarPeliculaAnioInvalido)

      expect do
        plataforma.registrar_contenido('Iron Man', nil, 'accion', repositorio_contenidos, fecha_agregado)
      end.to raise_error(ErrorAlInstanciarPeliculaAnioInvalido)
    end

    it 'dado que el titulo es inválido no se crea una película y se levanta el error correspondiente' do
      allow(Pelicula).to receive(:new).with(nil, anio, genero, fecha_agregado).and_raise(ErrorAlInstanciarPeliculaTituloInvalido)

      expect do
        plataforma.registrar_contenido(nil, 2008, 'accion', repositorio_contenidos, fecha_agregado)
      end.to raise_error(ErrorAlInstanciarPeliculaTituloInvalido)
    end

    it 'dado que el genero es inválido no se crea una película y se levanta el error correspondiente' do
      allow(Genero).to receive(:new).with('terror').and_raise(ErrorAlInstanciarPeliculaGeneroInvalido)

      expect do
        plataforma.registrar_contenido('Iron Man', 2008, 'terror', repositorio_contenidos, fecha_agregado)
      end.to raise_error(ErrorAlInstanciarPeliculaGeneroInvalido)
    end

    it 'dado que la película ya está registrada no se crea una película y se devuelve el error correspondiente' do
      allow(repositorio_contenidos).to receive(:save).with(pelicula).and_raise(ErrorAlPersistirPeliculaYaExistente)

      expect do
        plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, fecha_agregado)
      end.to raise_error(ErrorAlPersistirPeliculaYaExistente)
    end
  end
end
