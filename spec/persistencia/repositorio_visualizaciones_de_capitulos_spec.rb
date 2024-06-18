require 'integration_helper'
require_relative '../../dominio/visualizacion_de_capitulo'
require_relative '../../persistencia/repositorio_visualizaciones_de_capitulos'

describe RepositorioVisualizacionesDeCapitulos do
  let(:usuario) do
    usuario = Usuario.new('nicopaez@gmail.com', 123_456_789)
    RepositorioUsuarios.new.save(usuario)
  end

  let(:temporada_de_serie) do
    genero_de_temporada = Genero.new('drama')
    temporada_de_serie = FabricaDeContenido.crear_contenido('Game of Thrones - Temporada 1', 2011, genero_de_temporada, 'serie', Date.today, 10)
    RepositorioTemporadasDeSeries.new.save(temporada_de_serie)
  end

  let(:fecha) do
    Time.iso8601('2024-06-02T21:34:40+0000')
  end

  let(:numero_capitulo) do
    1
  end

  it 'deberia guardar y asignar id si la visualizacion es nueva' do
    visualizacion = VisualizacionDeCapitulo.new(usuario, temporada_de_serie, fecha, numero_capitulo)
    described_class.new.save(visualizacion)
    expect(visualizacion.id).to be > 0
  end

  it 'deberia poder contar cuantos capitulos de una temporada vio un usuario' do
    repo = described_class.new
    visualizacion = VisualizacionDeCapitulo.new(usuario, temporada_de_serie, fecha, numero_capitulo)
    described_class.new.save(visualizacion)
    visualizacion = VisualizacionDeCapitulo.new(usuario, temporada_de_serie, fecha, numero_capitulo + 1)
    described_class.new.save(visualizacion)
    visualizacion = VisualizacionDeCapitulo.new(usuario, temporada_de_serie, fecha, numero_capitulo + 2)
    described_class.new.save(visualizacion)
    expect(repo.count_visualizaciones_de_capitulos_por_usuario(usuario.id, temporada_de_serie.id)).to eq 3
  end
end
