require 'integration_helper'
Dir[File.join(__dir__, '../../controladores', '*.rb')].each { |file| require_relative file }

describe ControladorCalificacion do
  let(:controlador_calificacion) { described_class.new }
  let(:creador_de_calificacion) { instance_double('CreadorDeCalificacion') }
  let(:creador_de_calificacion_negativo) { instance_double('CreadorDeCalificacion') }
  let(:usuario) { instance_double('Usuario', id_telegram: 987_654_321, id: 1) }
  let(:pelicula) { instance_double('Pelicula', id: 2) }

  xit 'dado que el id_telegram, id_pelicula y calificacion son válidos se crea una calificacion exitosamente con estado 201' do
    allow(creador_de_calificacion).to receive(:crear) { Calificacion.new(usuario, pelicula, 1, 6) }

    controlador_calificacion.crear_calificacion(creador_de_calificacion)
    respuesta_json = JSON.parse(controlador_calificacion.respuesta)

    expect(respuesta_json['id'].to_i).to eq 6
    expect(controlador_calificacion.estado).to eq 201
  end

  xit 'dado que la calificacion es negativa la respuesta contiene estado 422 de error' do
    allow(creador_de_calificacion).to receive(:crear) { raise(ErrorAlInstanciarCalificacionInvalida) }

    controlador_calificacion.crear_calificacion(creador_de_calificacion)
    respuesta_json = JSON.parse(controlador_calificacion.respuesta)

    expect(respuesta_json['error']).to eq 'Entidad no procesable'
    expect(controlador_calificacion.estado).to eq 422
  end
end
