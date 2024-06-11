require 'integration_helper'
require_relative '../../dominio/pelicula'
require_relative '../../persistencia/repositorio_peliculas'

describe RepositorioPeliculas do
  let(:repositorio) { described_class.new }
  let(:anio_de_estreno) { instance_double('AnioDeEstreno', anio: 2008) }
  let(:genero_de_pelicula) { instance_double('Genero', genero: 'accion') }
  let(:otro_genero_de_pelicula) { instance_double('Genero', genero: 'drama') }

  it 'deberia guardar y asignar id si la película es nueva' do
    iron_man = Pelicula.new('Iron Man', anio_de_estreno, genero_de_pelicula)
    described_class.new.save(iron_man)
    expect(iron_man.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    cantidad_de_peliculas_iniciales = repositorio.all.size
    iron_man = Pelicula.new('Iron Man', anio_de_estreno, genero_de_pelicula)
    repositorio.save(iron_man)
    expect(repositorio.all.size).to be(cantidad_de_peliculas_iniciales + 1)
  end

  it 'guardar una pelicula con el mismo titulo y anio dos veces da un error' do
    pelicula1 = Pelicula.new('Iron Man', anio_de_estreno, genero_de_pelicula)
    repositorio.save(pelicula1)

    pelicula2 = Pelicula.new('Iron Man', anio_de_estreno, otro_genero_de_pelicula)
    expect { repositorio.save(pelicula2) }.to raise_error(ErrorAlPersistirPeliculaYaExistente)
  end

  it 'debería recuperar una película por título' do
    pelicula1 = Pelicula.new('Titanic', anio_de_estreno, genero_de_pelicula)
    repositorio.save(pelicula1)

    pelicula = repositorio.find_by_title('Titanic')
    expect(pelicula[0].titulo).to eq('Titanic')
  end

  it 'debería recuperar una película por título parcial' do
    pelicula1 = Pelicula.new('Catch me if you can', anio_de_estreno, genero_de_pelicula)
    repositorio.save(pelicula1)

    pelicula = repositorio.find_by_title('Catch')
    expect(pelicula[0].titulo).to eq 'Catch me if you can'
  end

  it 'debería recuperar la lista de los agregados en la ultima semana' do
    pelicula1 = Pelicula.new('Catch me if you can', anio_de_estreno, genero_de_pelicula)
    pelicula2 = Pelicula.new('Titanic', anio_de_estreno, genero_de_pelicula)
    repositorio.save(pelicula1)
    repositorio.save(pelicula2)

    pelicula = repositorio.ultimos_agregados
    expect(pelicula[0].titulo).to eq 'Catch me if you can'
    expect(pelicula[1].titulo).to eq 'Titanic'
  end
end
