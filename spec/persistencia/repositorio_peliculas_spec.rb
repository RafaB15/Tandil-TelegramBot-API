require 'integration_helper'
require_relative '../../dominio/pelicula'
require_relative '../../persistencia/repositorio_peliculas'

describe RepositorioPeliculas do
  it 'deberia guardar y asignar id si la película es nueva' do
    iron_man = CreadorDePelicula.new('Iron Man', 2008, 'accion').crear
    described_class.new.save(iron_man)
    expect(iron_man.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_peliculas_iniciales = repositorio.all.size
    iron_man = CreadorDePelicula.new('Iron Man', 2008, 'accion').crear
    repositorio.save(iron_man)
    expect(repositorio.all.size).to be(cantidad_de_peliculas_iniciales + 1)
  end
end
