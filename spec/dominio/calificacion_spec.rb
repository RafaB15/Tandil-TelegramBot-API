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

  it 'debe cambiar la calificacion cuando hace una recalificacion' do
    puntaje_nuevo = 4
    expect(calificacion.recalificar(puntaje_nuevo)).to eq 5
  end

  it 'debe levantar un error cuando el puntaje de recalificacion es negativo' do
    puntaje_nuevo = -1

    expect { calificacion.recalificar(puntaje_nuevo) }.to raise_error(ErrorAlInstanciarCalificacionInvalida)
  end
end
