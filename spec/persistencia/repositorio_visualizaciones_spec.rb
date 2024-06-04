require 'integration_helper'
require_relative '../../dominio/visualizacion'
require_relative '../../persistencia/repositorio_visualizaciones'

describe RepositorioVisualizaciones do
  let(:usuario) do
    usuario = Usuario.new('nicopaez@gmail.com', 123_456_789)
    RepositorioUsuarios.new.save(usuario)
  end

  let(:pelicula) do
    pelicula = Pelicula.new('Nair', AnioDeEstreno.new(2024), 'Drama', 2)
    RepositorioPeliculas.new.save(pelicula)
  end

  it 'deberia guardar y asignar id si la visualizacion es nueva' do
    visualizacion = Visualizacion.new(usuario, pelicula, '2024-06-02T21:34:40+0000')
    described_class.new.save(visualizacion)
    expect(visualizacion.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_visualizaciones_iniciales = repositorio.all.size
    visualizacion = Visualizacion.new(usuario, pelicula, '2024-06-02T21:34:40+0000')
    repositorio.save(visualizacion)
    expect(repositorio.all.size).to be(cantidad_de_visualizaciones_iniciales + 1)
  end
end
