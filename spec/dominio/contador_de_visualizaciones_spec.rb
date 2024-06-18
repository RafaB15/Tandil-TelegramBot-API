require_relative '../../dominio/contador_de_visualizaciones'

describe ContadorDeVisualizaciones do
  let(:usuario) { instance_double('Usuario', email: 'juan@gmail.com', id: 1) }
  let(:pelicula1) { instance_double('Pelicula', titulo: 'Rapidos y furiosos', anio: 2021, genero: 'accion', id: 1) }
  let(:pelicula2) { instance_double('Pelicula', titulo: 'Somos tres', anio: 2020, genero: 'comedia', id: 2) }
  let(:pelicula3) { instance_double('Pelicula', titulo: 'Nahir', anio: 2019, genero: 'drama', id: 3) }
  let(:pelicula4) { instance_double('Pelicula', titulo: 'Lucha', anio: 2021, genero: 'accion', id: 4) }

  describe 'obtener_mas_vistos' do
    let(:visualizaciones1) do
      [
        instance_double('Visualizacion', usuario:, pelicula: pelicula1, fecha: Time.now, id: 1),
        instance_double('Visualizacion', usuario:, pelicula: pelicula1, fecha: Time.now, id: 2),
        instance_double('Visualizacion', usuario:, pelicula: pelicula2, fecha: Time.now, id: 3),
        instance_double('Visualizacion', usuario:, pelicula: pelicula2, fecha: Time.now, id: 4),
        instance_double('Visualizacion', usuario:, pelicula: pelicula2, fecha: Time.now, id: 5),
        instance_double('Visualizacion', usuario:, pelicula: pelicula3, fecha: Time.now, id: 6)
      ]
    end
    let(:visualizaciones2) do
      [
        instance_double('Visualizacion', usuario:, pelicula: pelicula1, fecha: Time.now, id: 1),
        instance_double('Visualizacion', usuario:, pelicula: pelicula2, fecha: Time.now, id: 2),
        instance_double('Visualizacion', usuario:, pelicula: pelicula3, fecha: Time.now, id: 3),
        instance_double('Visualizacion', usuario:, pelicula: pelicula4, fecha: Time.now, id: 4)
      ]
    end
    let(:contador1) { described_class.new(visualizaciones1) }
    let(:contador2) { described_class.new(visualizaciones2) }

    it 'devuelve los 3 primeros contenidos con más visualizaciones' do
      result = contador1.obtener_mas_vistos

      expect(result).to eq([
                             { id: 2, contenido: { titulo: 'Somos tres', anio: 2020, genero: 'comedia' }, vistas: 3 },
                             { id: 1, contenido: { titulo: 'Rapidos y furiosos', anio: 2021, genero: 'accion' }, vistas: 2 },
                             { id: 3, contenido: { titulo: 'Nahir', anio: 2019, genero: 'drama' }, vistas: 1 }
                           ])
    end

    it 'devuelve los 3 primeros contenidos en orden alfabético cuando hay tienen la misma cantidad de visualizaciones' do
      result = contador2.obtener_mas_vistos

      expect(result).to eq([
                             { id: 4, contenido: { titulo: 'Lucha', anio: 2021, genero: 'accion' }, vistas: 1 },
                             { id: 3, contenido: { titulo: 'Nahir', anio: 2019, genero: 'drama' }, vistas: 1 },
                             { id: 1, contenido: { titulo: 'Rapidos y furiosos', anio: 2021, genero: 'accion' }, vistas: 1 }
                           ])
    end
  end
end
