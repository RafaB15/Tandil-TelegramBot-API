require 'integration_helper'
require_relative '../../dominio/pelicula'
require_relative '../../persistencia/repositorio_peliculas'

describe RepositorioPeliculas do
  let(:repositorio) { described_class.new }
  let(:genero_de_pelicula) { instance_double('Genero', genero: 'accion') }
  let(:otro_genero_de_pelicula) { instance_double('Genero', genero: 'drama') }

  it 'deberia guardar y asignar id si la película es nueva' do
    iron_man = Pelicula.new('Iron Man', 2008, genero_de_pelicula)
    described_class.new.save(iron_man)
    expect(iron_man.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    cantidad_de_peliculas_iniciales = repositorio.all.size
    iron_man = Pelicula.new('Iron Man', 2008, genero_de_pelicula)
    repositorio.save(iron_man)
    expect(repositorio.all.size).to be(cantidad_de_peliculas_iniciales + 1)
  end

  it 'debería recuperar una película por título' do
    pelicula1 = Pelicula.new('Titanic', 2008, genero_de_pelicula)
    repositorio.save(pelicula1)

    pelicula = repositorio.find_by_title('Titanic')
    expect(pelicula[0].titulo).to eq('Titanic')
  end

  it 'debería recuperar una película por título parcial' do
    pelicula1 = Pelicula.new('Catch me if you can', 2008, genero_de_pelicula)
    repositorio.save(pelicula1)

    pelicula = repositorio.find_by_title('Catch')
    expect(pelicula[0].titulo).to eq 'Catch me if you can'
  end

  it 'debería recuperar la lista de los agregados en la ultima semana' do
    pelicula1 = Pelicula.new('Catch me if you can', 2008, genero_de_pelicula)
    pelicula2 = Pelicula.new('Titanic', 2008, genero_de_pelicula)
    repositorio.save(pelicula1)
    repositorio.save(pelicula2)

    pelicula = repositorio.agregados_despues_de_fecha(Date.today - 7)
    expect(pelicula[0].titulo).to eq 'Catch me if you can'
    expect(pelicula[1].titulo).to eq 'Titanic'
  end

  it 'debería recuperar solo las películas agregadas en la última semana, sin incluir más viejas' do
    fecha_vieja = Date.today - 8
    hoy = Date.today

    pelicula1 = Pelicula.new('Catch me if you can', 2008, genero_de_pelicula, fecha_vieja)
    pelicula2 = Pelicula.new('Titanic', 2008, genero_de_pelicula, hoy)
    repositorio.save(pelicula1)
    repositorio.save(pelicula2)

    pelicula = repositorio.agregados_despues_de_fecha(Date.today - 7)
    expect(pelicula.size).to eq 1
    expect(pelicula[0].titulo).to eq 'Titanic'
  end
end
