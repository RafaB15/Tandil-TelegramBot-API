require 'integration_helper'
Dir[File.join(__dir__, '../../lib', '*.rb')].each { |file| require_relative file }

describe GeneradorDeRespuestasHTTP do
  let(:generador_de_respuestas_http) { described_class.new }

  describe 'enviar_version' do
    it 'debe devolver un json con la version y estado 200' do
      generador_de_respuestas_http.enviar_version('0.0.1')

      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['version']).to eq '0.0.1'
      expect(generador_de_respuestas_http.estado).to eq 200
    end
  end

  describe 'crear_usuario' do
    let(:creador_de_usuario) { instance_double('CreadorDesuario') }

    it 'dado que el email y el id_telegram son validos se crea un usuario exitosamente con estado 201' do
      creador_de_usuario = CreadorDeUsuario.new('juan@gmail.com', 123_456_789)

      generador_de_respuestas_http.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['id'].to_i).to be > 0
      expect(generador_de_respuestas_http.estado).to eq 201
    end

    it 'dado que el email es invalido no se crea el usuario y se devuelve un estado 422' do
      allow(creador_de_usuario).to receive(:crear) { raise(ErrorAlInstanciarUsuarioEmailInvalido) }

      generador_de_respuestas_http.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['error']).to eq 'Entidad no procesable'
      expect(generador_de_respuestas_http.estado).to eq 422
    end

    it 'dado que ya existe un usuario con este id_telegram no se crea el usuario y se devuelve un estado 409' do
      allow(creador_de_usuario).to receive(:crear) { raise(ErrorAlPersistirUsuarioYaExistente) }

      generador_de_respuestas_http.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json).to include('error' => 'Conflicto', 'details' => { 'field' => 'id_telegram' })
      expect(generador_de_respuestas_http.estado).to eq 409
    end

    it 'dado que ya existe un usuario con este email no se crea el usuario y se devuelve un estado 409' do
      allow(creador_de_usuario).to receive(:crear) { raise(ErrorAlPersistirEmailYaExistente) }

      generador_de_respuestas_http.crear_usuario(creador_de_usuario)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json).to include('error' => 'Conflicto', 'details' => { 'field' => 'email' })
      expect(generador_de_respuestas_http.estado).to eq 409
    end
  end

  describe 'crear_pelicula' do
    let(:creador_de_pelicula) { instance_double('CreadorDesuario') }

    it 'dado que el titulo, anio y genero son válidos se crea una película exitosamente con estado 201' do
      creador_de_pelicula = CreadorDePelicula.new('Iron Man', 2008, 'accion')

      generador_de_respuestas_http.crear_pelicula(creador_de_pelicula)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['id'].to_i).to be > 0
      expect(generador_de_respuestas_http.estado).to eq 201
    end

    it 'dado que el anio es inválido no se crea una película y se devuelve un estado 400' do
      allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlInstanciarPeliculaAnioInvalido) }

      generador_de_respuestas_http.crear_pelicula(creador_de_pelicula)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json).to include('error' => 'Solicitud Incorrecta', 'message' => 'El parametro requerido anio debe ser un año positivo')
      expect(generador_de_respuestas_http.estado).to eq 400
    end

    it 'dado que el titulo es inválido no se crea una película y se devuelve un estado 400' do
      allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlInstanciarPeliculaTituloInvalido) }

      generador_de_respuestas_http.crear_pelicula(creador_de_pelicula)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json).to include('error' => 'Solicitud Incorrecta', 'message' => 'El parametro requerido titulo debe ser un nombre')
      expect(generador_de_respuestas_http.estado).to eq 400
    end

    it 'dado que el genero es inválido no se crea una película y se devuelve un estado 400' do
      allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlInstanciarPeliculaGeneroInvalido) }

      generador_de_respuestas_http.crear_pelicula(creador_de_pelicula)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json).to include('error' => 'Solicitud Incorrecta', 'message' => 'El parametro requerido genero debe ser drama, accion o comedia')
      expect(generador_de_respuestas_http.estado).to eq 400
    end

    it 'dado que la película ya está registrada no se crea una película y se devuelve un estado 409' do
      allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlPersistirPeliculaYaExistente) }

      generador_de_respuestas_http.crear_pelicula(creador_de_pelicula)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json).to include('error' => 'Conflicto', 'message' => 'Ya existe una pelicula con el mismo titulo y año.', 'details' => { 'field' => 'titulo anio' })
      expect(generador_de_respuestas_http.estado).to eq 409
    end
  end

  describe 'crear_visualizacion' do
    let(:creador_de_visualizacion) { instance_double('CreadorDeVisualizacion') }
    let(:usuario) { instance_double('Usuario', email: 'juan@gmail.com', id: 1) }
    let(:pelicula) { instance_double('Pelicula', id: 2) }

    it 'dado que el id_pelicula, id_usuario y fecha son válidos se crea una visualización exitosamente con estado 201' do
      allow(creador_de_visualizacion).to receive(:crear) { Visualizacion.new(usuario, pelicula, Time.iso8601('2024-06-02T23:34:40+0000'), 10) }

      generador_de_respuestas_http.crear_visualizacion(creador_de_visualizacion)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['id'].to_i).to eq 10
      expect(generador_de_respuestas_http.estado).to eq 201
    end
  end

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
      generador_de_respuestas_http.obtener_mas_vistos(RepositorioVisualizaciones.new.all)
      mas_vistos = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(mas_vistos.size).to eq 3
    end
  end

  describe 'crear_calificacion' do
    let(:creador_de_calificacion) { instance_double('CreadorDeCalificacion') }
    let(:usuario) { instance_double('Usuario', id_telegram: 987_654_321, id: 1) }
    let(:pelicula) { instance_double('Pelicula', id: 2) }

    it 'dado que el id_telegram, id_pelicula y calificacion son válidos se crea una calificacion exitosamente con estado 201' do
      allow(creador_de_calificacion).to receive(:crear) { Calificacion.new(usuario, pelicula, 1, 6) }

      generador_de_respuestas_http.crear_calificacion(creador_de_calificacion)
      respuesta_json = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(respuesta_json['id'].to_i).to eq 6
      expect(generador_de_respuestas_http.estado).to eq 201
    end
  end

  describe 'aniadir_favorito' do
    let(:creador_de_favoritos) { instance_double('CreadorDeCalificacion') }
    let(:usuario) { instance_double('Usuario', id_telegram: 987_654_321, id: 1, email: 'test@gmail.com') }
    let(:pelicula) { instance_double('Pelicula', id: 2) }

    it 'dado un mail y un contenido, aniado ese contenido como favorito para el usuario con ese email' do
      allow(creador_de_favoritos).to receive(:crear) { Favorito.new(usuario, pelicula) }

      generador_de_respuestas_http.aniadir_favorito(creador_de_favoritos)
      json_response = JSON.parse(generador_de_respuestas_http.respuesta)

      expect(generador_de_respuestas_http.estado).to eq 201
      expect(json_response['id']).to be > 0
    end
  end
end
