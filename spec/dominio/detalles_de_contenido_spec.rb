require 'integration_helper'
require_relative '../../dominio/detalles_de_contenido/detalles_de_contenido'

describe DetallesDeContenido do
  subject(:detalles_de_contenido) do
    contenido = instance_double('Contenido', titulo: 'titulo', anio: 2000)

    detalles_de_contenido = described_class.new(contenido, 'premios', 'director', 'sinopsis')
    detalles_de_contenido.actualizar_fue_visto(true)

    detalles_de_contenido
  end

  describe 'modelo' do
    it { is_expected.to respond_to(:titulo) }
    it { is_expected.to respond_to(:anio) }
    it { is_expected.to respond_to(:premios) }
    it { is_expected.to respond_to(:director) }
    it { is_expected.to respond_to(:sinopsis) }
    it { is_expected.to respond_to(:fue_visto) }
  end

  it 'debe devolver el titulo de una serie correctamente' do
    contenido = instance_double('TemporadaDeSerie', titulo_de_serie: 'Friends')
    allow(contenido).to receive(:is_a?).with(Pelicula).and_return(false)
    allow(contenido).to receive(:is_a?).with(TemporadaDeSerie).and_return(true)

    expect(contenido).to receive(:is_a?).with(TemporadaDeSerie)

    detalle_de_contenido = described_class.new(contenido, 'premios', 'director', 'sinopsis')

    expect(detalle_de_contenido.titulo).to eq 'Friends'
  end
end
