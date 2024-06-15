require 'integration_helper'
require_relative '../../dominio/calificacion'
require_relative '../../persistencia/repositorio_calificaciones'

describe RepositorioCalificaciones do
  let(:usuario) do
    usuario = Usuario.new('nicopaez@gmail.com', 123_456_789)
    RepositorioUsuarios.new.save(usuario)
  end

  let(:pelicula) do
    genero_de_pelicula = Genero.new('drama')
    pelicula = Pelicula.new('Nair', 2024, genero_de_pelicula)
    RepositorioPeliculas.new.save(pelicula)
  end

  let(:fecha) do
    Time.iso8601('2024-06-02T21:34:40+0000')
  end

  let(:visualizacion) do
    visualizacion = Visualizacion.new(usuario, pelicula, fecha)
    RepositorioVisualizaciones.new.save(visualizacion)
  end

  it 'deberia guardar y asignar id si la calificacion es nueva' do
    calificacion = Calificacion.new(usuario, pelicula, 5)
    described_class.new.save(calificacion)
    expect(calificacion.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_calificaciones_iniciales = repositorio.all.size
    calificacion = Calificacion.new(usuario, pelicula, 5)
    repositorio.save(calificacion)
    expect(repositorio.all.size).to be(cantidad_de_calificaciones_iniciales + 1)
  end
end
