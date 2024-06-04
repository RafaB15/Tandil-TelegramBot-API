require 'integration_helper'
require_relative '../../dominio/pelicula'
require_relative '../../persistencia/repositorio_peliculas'

describe RepositorioPeliculas do
  let(:anio_de_estreno) { instance_double('AnioDeEstreno', anio: 2008) }
  let(:genero_de_pelicula) { instance_double('Genero', genero: 'accion') }

  it 'deberia guardar y asignar id si la película es nueva' do
    iron_man = Pelicula.new('Iron Man', anio_de_estreno, genero_de_pelicula)
    described_class.new.save(iron_man)
    expect(iron_man.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_peliculas_iniciales = repositorio.all.size
    iron_man = Pelicula.new('Iron Man', anio_de_estreno, genero_de_pelicula)
    repositorio.save(iron_man)
    expect(repositorio.all.size).to be(cantidad_de_peliculas_iniciales + 1)
  end
end
