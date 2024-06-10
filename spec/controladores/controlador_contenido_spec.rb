require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorContenido do
  let(:controlador_contenido) { described_class.new }
  let(:creador_de_pelicula) { instance_double('CreadorDesuario') }

  it 'dado que el titulo, anio y genero son válidos se crea una película exitosamente con estado 201' do
    creador_de_pelicula = CreadorDePelicula.new('Iron Man', 2008, 'accion')
    controlador_contenido.crear_pelicula(creador_de_pelicula)
    respuesta_json = JSON.parse(controlador_contenido.respuesta)
    expect(respuesta_json['id'].to_i).to be > 0
    expect(controlador_contenido.estado).to eq 201
  end

  it 'dado que el anio es inválido no se crea una película y se devuelve un estado 400' do
    allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlInstanciarPeliculaAnioInvalido) }
    controlador_contenido.crear_pelicula(creador_de_pelicula)
    respuesta_json = JSON.parse(controlador_contenido.respuesta)
    expect(respuesta_json).to include('error' => 'Solicitud Incorrecta', 'message' => 'El parametro requerido anio debe ser un año positivo')
    expect(controlador_contenido.estado).to eq 400
  end

  it 'dado que el titulo es inválido no se crea una película y se devuelve un estado 400' do
    allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlInstanciarPeliculaTituloInvalido) }
    controlador_contenido.crear_pelicula(creador_de_pelicula)
    respuesta_json = JSON.parse(controlador_contenido.respuesta)
    expect(respuesta_json).to include('error' => 'Solicitud Incorrecta', 'message' => 'El parametro requerido titulo debe ser un nombre')
    expect(controlador_contenido.estado).to eq 400
  end

  it 'dado que el genero es inválido no se crea una película y se devuelve un estado 400' do
    allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlInstanciarPeliculaGeneroInvalido) }
    controlador_contenido.crear_pelicula(creador_de_pelicula)
    respuesta_json = JSON.parse(controlador_contenido.respuesta)
    expect(respuesta_json).to include('error' => 'Solicitud Incorrecta', 'message' => 'El parametro requerido genero debe ser drama, accion o comedia')
    expect(controlador_contenido.estado).to eq 400
  end

  it 'dado que la película ya está registrada no se crea una película y se devuelve un estado 409' do
    allow(creador_de_pelicula).to receive(:crear) { raise(ErrorAlPersistirPeliculaYaExistente) }
    controlador_contenido.crear_pelicula(creador_de_pelicula)
    respuesta_json = JSON.parse(controlador_contenido.respuesta)
    expect(respuesta_json).to include('error' => 'Conflicto', 'message' => 'Ya existe una pelicula con el mismo titulo y año.', 'details' => { 'field' => 'titulo anio' })
    expect(controlador_contenido.estado).to eq 409
  end
end
