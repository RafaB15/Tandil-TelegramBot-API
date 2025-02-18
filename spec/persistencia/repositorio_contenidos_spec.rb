require 'integration_helper'
require_relative '../../dominio/pelicula'
require_relative '../../dominio/fabrica_de_contenido'
require_relative '../../persistencia/repositorio_contenidos'
require_relative '../../persistencia/repositorio_peliculas'
require_relative '../../persistencia/repositorio_temporadas_de_series'

describe RepositorioContenidos do
  let(:repositorio_contenidos) { described_class.new }
  let(:repositorio_peliculas) { RepositorioPeliculas.new }
  let(:repositorio_temporadas_de_series) { RepositorioTemporadasDeSeries.new }
  let(:genero_de_pelicula) { instance_double('Genero', genero: 'accion') }
  let(:otro_genero_de_pelicula) { instance_double('Genero', genero: 'drama') }

  it 'deberia recuperar todos' do
    cantidad_de_contenidos_iniciales = repositorio_contenidos.all.size
    iron_man = FabricaDeContenido.crear_contenido('Iron Man', 2008, genero_de_pelicula, 'pelicula')
    repositorio_peliculas.save(iron_man)
    expect(repositorio_contenidos.all.size).to be(cantidad_de_contenidos_iniciales + 1)
  end

  it 'debería recuperar una película por título' do
    pelicula1 = FabricaDeContenido.crear_contenido('Titanic', 2008, genero_de_pelicula, 'pelicula')
    repositorio_peliculas.save(pelicula1)

    pelicula = repositorio_contenidos.find_by_title('Titanic')
    expect(pelicula[0].titulo).to eq('Titanic')
  end

  it 'debería recuperar una película por título parcial' do
    pelicula1 = FabricaDeContenido.crear_contenido('Catch me if you can', 2008, genero_de_pelicula, 'pelicula')
    repositorio_peliculas.save(pelicula1)

    pelicula = repositorio_contenidos.find_by_title('Catch')
    expect(pelicula[0].titulo).to eq 'Catch me if you can'
  end

  it 'debería recuperar la lista de los agregados en la ultima semana' do
    pelicula1 = FabricaDeContenido.crear_contenido('Catch me if you can', 2008, genero_de_pelicula, 'pelicula')
    pelicula2 = FabricaDeContenido.crear_contenido('Titanic', 2008, genero_de_pelicula, 'pelicula')
    repositorio_peliculas.save(pelicula1)
    repositorio_peliculas.save(pelicula2)

    pelicula = repositorio_contenidos.agregados_despues_de_fecha(Date.today - 7)
    expect(pelicula[0].titulo).to eq 'Catch me if you can'
    expect(pelicula[1].titulo).to eq 'Titanic'
  end

  it 'debería recuperar solo las películas agregadas en la última semana, sin incluir más viejas' do
    fecha_vieja = Date.today - 8
    hoy = Date.today

    pelicula1 = FabricaDeContenido.crear_contenido('Catch me if you can', 2008, genero_de_pelicula, 'pelicula', fecha_vieja)
    pelicula2 = FabricaDeContenido.crear_contenido('Titanic', 2008, genero_de_pelicula, 'pelicula', hoy)
    repositorio_peliculas.save(pelicula1)
    repositorio_peliculas.save(pelicula2)

    pelicula = repositorio_contenidos.agregados_despues_de_fecha(Date.today - 7)
    expect(pelicula.size).to eq 1
    expect(pelicula[0].titulo).to eq 'Titanic'
  end
end
