require 'rspec'
Dir[File.join(__dir__, '../../dominio', '*.rb')].each { |file| require file }

describe 'Plataforma' do
  describe 'registrar_favorito' do
    let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:repositorio_favoritos) { instance_double('RepositorioFavoritos') }
    let(:usuario) { instance_double('Usuario') }
    let(:pelicula) { instance_double('Pelicula') }
    let(:serie) { instance_double('TemporadaDeSerie') }
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
      end.to raise_error(ErrorContenidoInexistente)
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
    let(:serie) { instance_double('TemporadaDeSerie') }
    let(:plataforma) { Plataforma.new(123, 456) }
    let(:fecha_agregado) { Date.new(2023, 4, 1) }

    before(:each) do
      allow(Genero).to receive(:new).with('accion').and_return(genero)
      allow(Pelicula).to receive(:new).with('Iron Man', 2008, genero, fecha_agregado, nil).and_return(pelicula)
      allow(TemporadaDeSerie).to receive(:new).with('Garfield', 2005, genero, 12, fecha_agregado, nil).and_return(serie)
      allow(repositorio_contenidos).to receive(:save).with(pelicula)
      allow(repositorio_contenidos).to receive(:save).with(serie)
    end

    it 'dado que el titulo, anio y genero son válidos se crea una película exitosamente con estado 201' do
      allow(pelicula).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(false)
      result = plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, 'pelicula', fecha_agregado)
      expect(result).to eq(pelicula)
    end

    it 'dado que el titulo es inválido no se crea una película y se levanta el error correspondiente' do
      allow(Pelicula).to receive(:new).with(nil, 2008, genero, fecha_agregado, nil).and_raise(ErrorAlInstanciarTituloInvalido)

      expect do
        plataforma.registrar_contenido(nil, 2008, 'accion', repositorio_contenidos, 'pelicula', fecha_agregado)
      end.to raise_error(ErrorAlInstanciarTituloInvalido)
    end

    it 'dado que el genero es inválido no se crea una película y se levanta el error correspondiente' do
      allow(Genero).to receive(:new).with('terror').and_raise(ErrorAlInstanciarGeneroInvalido)

      expect do
        plataforma.registrar_contenido('Iron Man', 2008, 'terror', repositorio_contenidos, 'pelicula', fecha_agregado)
      end.to raise_error(ErrorAlInstanciarGeneroInvalido)
    end

    xit 'dado que la película ya está registrada no se crea una película y se devuelve el error correspondiente' do
      allow(Genero).to receive(:new).with('accion').and_return(genero)
      allow(Pelicula).to receive(:new).with('Iron Man', 2008, genero, fecha_agregado, nil).and_return(pelicula)
      allow(pelicula).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(false)
      allow(repositorio_contenidos).to receive(:save).with(pelicula)
      plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, 'pelicula', fecha_agregado)

      allow(pelicula).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(ErrorAlPersistirContenidoYaExistente)
      expect do
        plataforma.registrar_contenido('Iron Man', 2008, 'accion', repositorio_contenidos, 'pelicula', fecha_agregado)
      end.to raise_error(ErrorAlPersistirContenidoYaExistente)
    end

    it 'dado que el titulo, anio, genero, tipo y cantidad de capitulos son válidos se crea una serie exitosamente con estado 201' do
      allow(serie).to receive(:contenido_existente?).with(repositorio_contenidos).and_return(false)
      result = plataforma.registrar_contenido('Garfield', 2005, 'accion', repositorio_contenidos, 'serie', fecha_agregado, 12)
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
    let(:temporada_de_serie) { instance_double('TemporadaDeSerie', id: 1) }
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
      pelicula = FabricaDeContenido.crear_contenido('Iron Man', 2008, 'accion', 'pelicula', Date.today - 4)
      allow(Pelicula).to receive(:new).with('Iron Man', 2008, 'accion', Date.today, nil).and_return(pelicula)
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

  describe 'obtener_contenido_detalles' do
    let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
    let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
    let(:repositorio_visualizaciones) { instance_double('RepositorioVisualizaciones') }
    let(:omdb_conector_api) { instance_double('OMDbConectorAPI') }
    let(:visualizacion) { instance_double('Visualizacion') }
    let(:id_telegram) { 123_456_789 }
    let(:usuario) { instance_double('Usuario', id: 1, id_telegram:) }
    let(:id_contenido) { 40 }
    let(:plataforma) { Plataforma.new(id_telegram, id_contenido) }

    def obtener_cuerpo(contenido)
      {
        'Title' => contenido.titulo,
        'Year' => contenido.anio,
        'Director' => 'James Cameron',
        'Plot' => 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
        'Awards' => 'Won 11 Oscars. 126 wins & 83 nominations total'
      }
    end

    def obtener_detalles_de_contenidos(contenido)
      premios = 'Won 11 Oscars. 126 wins & 83 nominations total'
      director = 'James Cameron'
      sinopsis = 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.'

      constructor_de_detalles_de_contenido = ConstructorDeDetallesDeContenido.new
      constructor_de_detalles_de_contenido.definir_contenido(contenido)
      constructor_de_detalles_de_contenido.definir_detalles(premios, director, sinopsis)
      constructor_de_detalles_de_contenido.construir
    end

    def antecedentes
      contenido = Pelicula.new('Titanic', 1977, 'drama')

      detalles_de_contenido_esperado = obtener_detalles_de_contenidos(contenido)

      cuerpo = obtener_cuerpo(contenido)
      respuesta_faraday = instance_double('RespuestaFaraday', status: 200, body: cuerpo.to_json)

      [contenido, detalles_de_contenido_esperado, respuesta_faraday]
    end

    it 'debería poder pedir mas detalles de un contenido con exito' do
      contenido, detalles_de_contenido_esperado, respuesta_faraday = antecedentes

      allow(repositorio_contenidos).to receive(:find).and_return(contenido)
      allow(omdb_conector_api).to receive(:detallar_contenido).and_return(respuesta_faraday)
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(nil)

      resultado = plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      expect(resultado.premios).to eq(detalles_de_contenido_esperado.premios)
      expect(resultado.director).to eq(detalles_de_contenido_esperado.director)
      expect(resultado.sinopsis).to eq(detalles_de_contenido_esperado.sinopsis)
    end

    it 'debería pedir mas detalles de un contenido que no esta en la BDD y levantar un error' do
      allow(repositorio_contenidos).to receive(:find).and_raise(ErrorContenidoInexistente)

      expect(repositorio_contenidos).to receive(:find).with(id_contenido)

      expect do
        plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      end.to raise_error(ErrorContenidoInexistente)
    end

    it 'deberia levantar un error de error inesperado de la API OMDb si esta devuelve un estado distinto de 200' do
      titulo = 'Harry Potter'
      contenido = Pelicula.new(titulo, 2000, 'accion')

      respuesta_faraday = instance_double('RespuestaFaraday', status: 500, body: {}.to_json)
      allow(repositorio_contenidos).to receive(:find).and_return(contenido)
      allow(omdb_conector_api).to receive(:detallar_contenido).and_return(respuesta_faraday)

      expect(omdb_conector_api).to receive(:detallar_contenido).with(titulo)

      expect do
        plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      end.to raise_error(ErrorInesperadoEnLaAPIDeOMDb)
    end

    it 'deberia levantar un error de error contenido no se encuentra en la BDD de OMDb si esta devuelve un response False' do
      titulo = 'Harry Potter'
      contenido = Pelicula.new(titulo, 2000, 'accion')

      respuesta_faraday = instance_double('RespuestaFaraday', status: 200, body: { 'Response' => 'False' }.to_json)
      allow(repositorio_contenidos).to receive(:find).and_return(contenido)
      allow(omdb_conector_api).to receive(:detallar_contenido).and_return(respuesta_faraday)

      expect(omdb_conector_api).to receive(:detallar_contenido).with(titulo)

      expect do
        plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      end.to raise_error(ErrorContenidoInexistenteEnLaAPIDeOMDb)
    end

    def obtener_cuerpo_con_campos_na(contenido)
      {
        'Title' => contenido.titulo,
        'Year' => contenido.anio,
        'Director' => 'N/A',
        'Plot' => 'N/A',
        'Awards' => 'N/A'
      }
    end

    def obtener_detalles_de_contenidos_con_parametros_na(contenido)
      constructor_de_detalles_de_contenido = ConstructorDeDetallesDeContenido.new
      constructor_de_detalles_de_contenido.definir_contenido(contenido)
      constructor_de_detalles_de_contenido.construir
    end

    def antecedentes_con_campos_na
      contenido = Pelicula.new('PeliculaSinDirectorNiPremiosEnOMDB', 2000, 'accion')

      detalles_de_contenido_esperado = obtener_detalles_de_contenidos_con_parametros_na(contenido)

      cuerpo = obtener_cuerpo_con_campos_na(contenido)
      respuesta_faraday = instance_double('RespuestaFaraday', status: 200, body: cuerpo.to_json)

      [contenido, detalles_de_contenido_esperado, respuesta_faraday]
    end

    it 'deberia devolver nil como valor de los campos que la API devuelve como N/A' do
      contenido, detalles_de_contenido_esperado, respuesta_faraday = antecedentes_con_campos_na

      allow(repositorio_contenidos).to receive(:find).and_return(contenido)
      allow(omdb_conector_api).to receive(:detallar_contenido).and_return(respuesta_faraday)
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(nil)

      expect(repositorio_usuarios).to receive(:find_by_id_telegram).with(id_telegram)

      resultado = plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      expect(resultado.titulo).to eq(detalles_de_contenido_esperado.titulo)
      expect(resultado.anio).to eq(detalles_de_contenido_esperado.anio)
    end

    it 'deberia devolver el campo fue visto como false si el usuario no lo vio' do
      contenido = Pelicula.new('Harry Potter', 2000, 'accion')

      respuesta_faraday = instance_double('RespuestaFaraday', status: 200, body: {}.to_json)
      allow(repositorio_contenidos).to receive(:find).and_return(contenido)
      allow(omdb_conector_api).to receive(:detallar_contenido).and_return(respuesta_faraday)
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(usuario)
      allow(repositorio_visualizaciones).to receive(:find_by_id_usuario_y_id_contenido).and_return(nil)

      expect(repositorio_visualizaciones).to receive(:find_by_id_usuario_y_id_contenido).with(usuario.id, id_contenido)

      resultado = plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      expect(resultado.fue_visto).to eq false
    end

    it 'deberia devolver el campo fue visto como true si el usuario ya lo vio' do
      contenido = Pelicula.new('Harry Potter', 2000, 'accion')

      respuesta_faraday = instance_double('RespuestaFaraday', status: 200, body: {}.to_json)
      allow(repositorio_contenidos).to receive(:find).and_return(contenido)
      allow(omdb_conector_api).to receive(:detallar_contenido).and_return(respuesta_faraday)
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(usuario)
      allow(repositorio_visualizaciones).to receive(:find_by_id_usuario_y_id_contenido).and_return(visualizacion)

      expect(repositorio_visualizaciones).to receive(:find_by_id_usuario_y_id_contenido).with(usuario.id, id_contenido)

      resultado = plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      expect(resultado.fue_visto).to eq true
    end

    def obtener_cuerpo_de_serie(serie)
      {
        'Title' => serie.titulo_de_serie,
        'Year' => serie.anio,
        'Director' => 'James Cameron',
        'Plot' => 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
        'Awards' => 'Won 11 Oscars. 126 wins & 83 nominations total'
      }
    end

    def obtener_detalles_de_contenidos_con_parametros_na(contenido)
      constructor_de_detalles_de_contenido = ConstructorDeDetallesDeContenido.new
      constructor_de_detalles_de_contenido.definir_contenido(contenido)
      constructor_de_detalles_de_contenido.construir
    end

    def antecedentes_para_serie
      contenido = TemporadaDeSerie.new('Friends - Temporada 1', 2000, 'accion', Date.today, 24)

      detalles_de_contenido_esperado = obtener_detalles_de_contenidos_con_parametros_na(contenido)

      cuerpo = obtener_cuerpo_de_serie(contenido)
      respuesta_faraday = instance_double('RespuestaFaraday', status: 200, body: cuerpo.to_json)

      [contenido, detalles_de_contenido_esperado, respuesta_faraday]
    end

    it 'debería poder pedir mas detalles de un contenido del tipo serie con exito' do
      contenido, detalles_de_contenido_esperado, respuesta_faraday = antecedentes_para_serie

      allow(repositorio_contenidos).to receive(:find).and_return(contenido)
      allow(omdb_conector_api).to receive(:detallar_contenido).and_return(respuesta_faraday)
      allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(nil)

      expect(omdb_conector_api).to receive(:detallar_contenido).with('Friends')

      resultado = plataforma.obtener_contenido_detalles(repositorio_usuarios, repositorio_contenidos, repositorio_visualizaciones, omdb_conector_api)
      expect(resultado.titulo).to eq(detalles_de_contenido_esperado.titulo)
      expect(resultado.anio).to eq(detalles_de_contenido_esperado.anio)
    end
  end
end
