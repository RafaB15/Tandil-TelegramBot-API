require 'integration_helper'
require_relative '../../dominio/calificacion'

describe Calificacion do
  subject(:calificacion) do
    usuario = instance_double('Usuario')
    pelicula = instance_double('Pelicula')

    described_class.new(usuario, pelicula, 5)
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:pelicula) }
    it { is_expected.to respond_to(:puntaje) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
  end

  it 'debe levantar un error cuando el puntaje es negativo' do
    usuario = instance_double('Usuario')
    pelicula = instance_double('Pelicula')
    puntaje = -1

    expect { described_class.new(usuario, pelicula, puntaje) }.to raise_error(ErrorAlInstanciarCalificacionInvalida)
  end

  it 'debe levantar un error cuando el puntaje es mayor a 5' do
    usuario = instance_double('Usuario')
    pelicula = instance_double('Pelicula')
    puntaje = 6

    expect { described_class.new(usuario, pelicula, puntaje) }.to raise_error(ErrorAlInstanciarCalificacionInvalida)
  end

  it 'debe borrar la calificacion anterior si existe una' do
    usuario = instance_double('Usuario')
    allow(usuario).to receive(:id).and_return(1)

    pelicula = instance_double('Pelicula')
    allow(pelicula).to receive(:id).and_return(1)

    calificacion = instance_double('Calificacion')
    repositorio_calificaciones = instance_double('RepositorioCalificaciones')

    allow(repositorio_calificaciones).to receive(:find_by_id_usuario_y_id_contenido).with(usuario.id, pelicula.id).and_return(calificacion)
    allow(calificacion).to receive(:es_una_recalificacion?).with(repositorio_calificaciones).and_return(true)

    expect(calificacion.es_una_recalificacion?(repositorio_calificaciones)).to be true
  end
end
