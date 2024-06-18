require 'integration_helper'
require_relative '../../dominio/temporada_de_serie'
require_relative '../../dominio/fabrica_de_contenido'
require_relative '../../persistencia/repositorio_temporadas_de_series'

describe RepositorioTemporadasDeSeries do
  let(:repositorio) { described_class.new }
  let(:genero_de_serie) { instance_double('Genero', genero: 'accion') }
  let(:otro_genero_de_serie) { instance_double('Genero', genero: 'drama') }

  it 'deberia guardar y asignar id si la serie es nueva' do
    flash = FabricaDeContenido.crear_contenido('Flash', 2001, genero_de_serie, 'serie', Date.today, 31)
    described_class.new.save(flash)
    expect(flash.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    cantidad_de_contenidos_iniciales = repositorio.all.size
    flash = FabricaDeContenido.crear_contenido('Flash', 2008, genero_de_serie, 'serie', Date.today, 23)
    repositorio.save(flash)
    expect(repositorio.all.size).to be(cantidad_de_contenidos_iniciales + 1)
  end

  it 'debería recuperar una serie por título' do
    serie1 = FabricaDeContenido.crear_contenido('You', 2008, genero_de_serie, 'serie', Date.today, 8)
    repositorio.save(serie1)

    serie = repositorio.find_by_title('You')
    expect(serie[0].titulo).to eq('You')
  end

  it 'debería recuperar una serie por título parcial' do
    serie1 = FabricaDeContenido.crear_contenido('Catch me if you can', 2008, genero_de_serie, 'serie', Date.today, 6)
    repositorio.save(serie1)

    serie = repositorio.find_by_title('Catch')
    expect(serie[0].titulo).to eq 'Catch me if you can'
  end

  it 'debería recuperar la lista de los agregados en la ultima semana' do
    serie1 = FabricaDeContenido.crear_contenido('Catch me if you can', 2008, genero_de_serie, 'serie', Date.today, 21)
    serie2 = FabricaDeContenido.crear_contenido('You', 2008, genero_de_serie, 'serie', Date.today, 9)
    repositorio.save(serie1)
    repositorio.save(serie2)

    serie = repositorio.agregados_despues_de_fecha(Date.today - 7)
    expect(serie[0].titulo).to eq 'Catch me if you can'
    expect(serie[1].titulo).to eq 'You'
  end

  it 'debería recuperar solo las series agregadas en la última semana, sin incluir más viejas' do
    fecha_vieja = Date.today - 8
    hoy = Date.today

    serie1 = FabricaDeContenido.crear_contenido('Catch me if you can', 2008, genero_de_serie, 'serie', fecha_vieja, 12)
    serie2 = FabricaDeContenido.crear_contenido('You', 2008, genero_de_serie, 'serie', hoy, 15)
    repositorio.save(serie1)
    repositorio.save(serie2)

    serie = repositorio.agregados_despues_de_fecha(Date.today - 7)
    expect(serie.size).to eq 1
    expect(serie[0].titulo).to eq 'You'
  end
end
