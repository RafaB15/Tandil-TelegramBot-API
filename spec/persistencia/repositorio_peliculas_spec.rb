require 'integration_helper'
require_relative '../../dominio/pelicula'
require_relative '../../persistencia/repositorio_peliculas'

describe RepositorioPeliculas do
  let(:anio_de_estreno) { instance_double('AnioDeEstrena', anio: 2008) }

  it 'deberia guardar y asignar id si la película es nueva' do
    iron_man = Pelicula.new('Iron Man', anio_de_estreno, 'accion')
    described_class.new.save(iron_man)
    expect(iron_man.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_peliculas_iniciales = repositorio.all.size
    iron_man = Pelicula.new('Iron Man', anio_de_estreno, 'accion')
    repositorio.save(iron_man)
    expect(repositorio.all.size).to be(cantidad_de_peliculas_iniciales + 1)
  end
end
