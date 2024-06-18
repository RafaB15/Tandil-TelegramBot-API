require 'rspec'
Dir[File.join(__dir__, '../../dominio', '*.rb')].each { |file| require file }

describe 'Plataforma' do
  describe 'registrar_favorito' do
    let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:repositorio_favoritos) { instance_double('RepositorioFavoritos') }
    let(:usuario) { instance_double('Usuario') }
    let(:pelicula) { instance_double('Pelicula') }
    let(:serie) { instance_double('Serie') }
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
    let(:pelicula) { instance_double('Pelicula', id: 2) }
    let(:visualizacion) { instance_double('Visualizacion') }
    let(:calificacion) { instance_double('Calificacion') }
    let(:plataforma) { Plataforma.new(123, pelicula.id) }

    before(:each) do
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(usuario)
      allow(repositorio_contenidos).to receive(:find).and_return(pelicula)
      allow(repositorio_visualizaciones).to receive(:find_by_id_usuario_y_id_contenido).and_return(visualizacion)
      allow(Calificacion).to receive(:new).and_return(calificacion)
      allow(repositorio_calificaciones).to receive(:save)
    end

    it 'dado que el id_telegram, id_pelicula y calificacion son válidos se crea una calificacion' do
      calificacion = instance_double(Calificacion)

      allow(Calificacion).to receive(:new).with(usuario, pelicula, 5).and_return(calificacion)
      allow(repositorio_calificaciones).to receive(:save).with(calificacion)

      allow(repositorio_calificaciones).to receive(:find_by_id_usuario_y_id_contenido).with(usuario.id, pelicula.id).and_return(nil)
      allow(repositorio_calificaciones).to receive(:save).and_return(calificacion)
      allow(calificacion).to receive(:recalificar).and_return(5)

      puntaje = 5
      result = plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)

      expect(result).to eq([calificacion, nil])
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

    it 'debería actualizar la calificación si ya existe' do
      calificacion = instance_double(Calificacion)

      allow(Calificacion).to receive(:new).with(usuario, pelicula, 5).and_return(calificacion)
      allow(repositorio_calificaciones).to receive(:save).with(calificacion)

      allow(repositorio_calificaciones).to receive(:find_by_id_usuario_y_id_contenido).with(usuario.id, pelicula.id).and_return(calificacion)
      allow(repositorio_calificaciones).to receive(:save).and_return(calificacion)
      allow(calificacion).to receive(:recalificar).and_return(5)

      puntaje = 4
      result = plataforma.registrar_calificacion(puntaje, repositorio_contenidos, repositorio_usuarios, repositorio_visualizaciones, repositorio_calificaciones)

      expect(result).to eq([calificacion, 5])
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
      allow(Usuario).to receive(:new).with('usuario@test.com', 123).and_return(usuario)
      allow(usuario).to receive(:usuario_existente?).with(repositorio_usuarios).and_return(false)
      allow(repositorio_usuarios).to receive(:save).with(usuario)

      result = plataforma.registrar_usuario('usuario@test.com', 123, repositorio_usuarios)
      expect(result).to eq(usuario)
    end
  end

  describe 'registrar_contenido' do
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:genero) { instance_double('Genero') }
    let(:pelicula) { instance_double('Pelicula') }
    let(:serie) { instance_double('Serie') }
    let(:plataforma) { Plataforma.new(123, 456) }
    let(:fecha_agregado) { Date.new(2023, 4, 1) }

    before(:each) do
      allow(Genero).to receive(:new).with('accion').and_return(genero)
      allow(Pelicula).to receive(:new).with('Iron Man', 2008, genero, fecha_agregado, nil, nil).and_return(pelicula)
      allow(Serie).to receive(:new).with('Garfield', 2005, genero, fecha_agregado, 12, nil).and_return(serie)
      allow(repositorio_contenidos).to receive(:save).with(pelicula)
      allow(repositorio_contenidos).to receive(:save).with(serie)
    end

    it 'dado que el titulo, anio y genero son válidos se crea una película exitosamente con estado 201' do
      allow(pelicula).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(false)
      result = plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, fecha_agregado)
      expect(result).to eq(pelicula)
    end

    it 'dado que el titulo es inválido no se crea una película y se levanta el error correspondiente' do
      allow(Pelicula).to receive(:new).with(nil, 2008, genero, fecha_agregado, nil, nil).and_raise(ErrorAlInstanciarTituloInvalido)

      expect do
        plataforma.registrar_contenido(nil, 2008, 'accion', repositorio_contenidos, fecha_agregado)
      end.to raise_error(ErrorAlInstanciarTituloInvalido)
    end

    it 'dado que el genero es inválido no se crea una película y se levanta el error correspondiente' do
      allow(Genero).to receive(:new).with('terror').and_raise(ErrorAlInstanciarGeneroInvalido)

      expect do
        plataforma.registrar_contenido('Iron Man', 2008, 'terror', repositorio_contenidos, fecha_agregado)
      end.to raise_error(ErrorAlInstanciarGeneroInvalido)
    end

    xit 'dado que la película ya está registrada no se crea una película y se devuelve el error correspondiente' do
      allow(Genero).to receive(:new).with('accion').and_return(genero)
      allow(Pelicula).to receive(:new).with('Iron Man', 2008, genero, fecha_agregado, nil, nil).and_return(pelicula)
      allow(pelicula).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(false)
      allow(repositorio_contenidos).to receive(:save).with(pelicula)
      plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, fecha_agregado)

      allow(pelicula).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(ErrorAlPersistirContenidoYaExistente)
      expect do
        plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, fecha_agregado)
      end.to raise_error(ErrorAlPersistirContenidoYaExistente)
    end

    it 'dado que el titulo, anio, genero, tipo y cantidad de capitulos son válidos se crea una serie exitosamente con estado 201' do
      allow(serie).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(false)
      result = plataforma.registrar_contenido('Garfield', 2005, 'accion', repositorio_contenidos, fecha_agregado, 12)
      expect(result).to eq(serie)
    end
  end

  describe 'obtener_contenido_por_titulo' do
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:plataforma) { Plataforma.new }

    it 'debería devolver una lista de películas con el título dado' do
      pelicula = instance_double('Los 7 enanitos')
      allow(repositorio_contenidos).to receive(:find_by_title).and_return([pelicula])

      result = plataforma.obtener_contenido_por_titulo('Los 7 enanitos', repositorio_contenidos)
      expect(result).to eq([pelicula])
    end

    it 'debería devolver una lista vacia si no hay películas con el título dado' do
      allow(repositorio_contenidos).to receive(:find_by_title).and_return([])

      result = plataforma.obtener_contenido_por_titulo('Amistad por siempre', repositorio_contenidos)
      expect(result).to eq([])
    end
  end

  describe 'registrar_visualizacion' do
    let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:repositorio_visualizaciones) { instance_double('RepositorioVisualizaciones') }
    let(:repositorio_visualizaciones_de_capitulos) { instance_double('RepositorioVisualizacionesDeCapitulos') }
    let(:temporada_de_serie) { instance_double('Serie', id: 1) }
    let(:visualizacion_de_capitulo) { instance_double('VisualizacionDeCapitulo') }
    let(:usuario) { instance_double('Usuario', id: 1) }
    let(:pelicula) { instance_double('Pelicula') }
    let(:visualizacion) { instance_double('Visualizacion') }
    let(:plataforma) { Plataforma.new(123, 456) }

    before(:each) do
      allow(repositorio_usuarios).to receive(:find_by_email).and_return(usuario)
      allow(Visualizacion).to receive(:new).and_return(visualizacion)
      allow(repositorio_visualizaciones).to receive(:find)
      allow(repositorio_visualizaciones).to receive(:save)
      allow(repositorio_visualizaciones_de_capitulos).to receive(:save)
    end

    it 'debería crear y guardar una nueva visualización' do
      fecha = '2023-04-01T12:00:00Z'
      allow(repositorio_contenidos).to receive(:find).and_return(pelicula)
      expect(Visualizacion).to receive(:new).with(usuario, pelicula, Time.iso8601(fecha))
      expect(repositorio_visualizaciones).to receive(:save).with(visualizacion)
      result = plataforma.registrar_visualizacion(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, nil, nil, '', fecha)
      expect(result).to eq(visualizacion)
    end

    it 'debería registrar una visualización de un capítulo de una temporada correctamente' do
      fecha = '2023-04-01T12:00:00Z'
      allow(repositorio_contenidos).to receive(:find).and_return(temporada_de_serie)
      allow(VisualizacionDeCapitulo).to receive(:new).and_return(visualizacion_de_capitulo)
      allow(repositorio_visualizaciones_de_capitulos).to receive(:count_visualizaciones_de_capitulos_por_usuario).and_return(0)
      result = plataforma.registrar_visualizacion(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, repositorio_visualizaciones_de_capitulos, 1, '', fecha)
      expect(result).to eq(visualizacion_de_capitulo)
    end

    it 'deberia registrar una temporada como vista cuando una temporada llega a 4 capitulos vistos' do
      fecha = '2023-04-01T12:00:00Z'
      allow(repositorio_contenidos).to receive(:find).and_return(temporada_de_serie)
      allow(repositorio_visualizaciones_de_capitulos).to receive(:count_visualizaciones_de_capitulos_por_usuario).and_return(4)

      expect(repositorio_visualizaciones).to receive(:save)
      plataforma.registrar_visualizacion(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, repositorio_visualizaciones_de_capitulos, 1, '', fecha)
    end
  end

  describe 'obtener_contenido_ultimos_agregados' do
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:plataforma) { Plataforma.new }

    it 'debería devolver una lista de películas agregadas en la última semana' do
      pelicula = FabricaDeContenido.crear_contenido('Iron Man', 2008, 'accion', Date.today - 4)
      allow(Pelicula).to receive(:new).with('Iron Man', 2008, 'accion', Date.today, nil, nil).and_return(pelicula)
      allow(repositorio_contenidos).to receive(:agregados_despues_de_fecha).and_return([pelicula])

      result = plataforma.obtener_contenido_ultimos_agregados(repositorio_contenidos)
      expect(result).to eq([pelicula])
    end

    it 'debería devolver una lista vacía si no hay películas agregadas en la última semana' do
      allow(repositorio_contenidos).to receive(:agregados_despues_de_fecha).and_return([])

      result = plataforma.obtener_contenido_ultimos_agregados(repositorio_contenidos)
      expect(result).to eq([])
    end
  end

  describe 'obtener_visualizacion_mas_vistos' do
    let(:repositorio_visualizaciones) { instance_double('RepositorioVisualizaciones') }
    let(:plataforma) { Plataforma.new }
    let(:contador) { instance_double('ContadorDeVisualizaciones') }
    let(:visualizacion) { instance_double('Visualizacion') }
    let(:visualizaciones) { [visualizacion] }

    before(:each) do
      allow(repositorio_visualizaciones).to receive(:all).and_return(visualizaciones)
      allow(ContadorDeVisualizaciones).to receive(:new).and_return(contador)
      allow(contador).to receive(:obtener_mas_vistos).and_return(visualizacion)
    end

    it 'debería devolver la visualización más vista' do
      result = plataforma.obtener_visualizacion_mas_vistos(repositorio_visualizaciones)
      expect(result).to eq(visualizacion)
    end
  end

  # describe 'registrar_visualizacion_capitulo' do
  #   let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
  #   let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }

  #   let(:usuario) { instance_double('Usuario') }
  #   let(:plataforma) { Plataforma.new(123, 456) }
  #   let(:fecha) { '2023-04-01T12:00:00Z' }
  #   let(:numero_capitulo) { 1 }

  #   before(:each) do
  #     allow(repositorio_usuarios).to receive(:find_by_email).and_return(usuario)
  #
  #
  #   end

  # end
end
