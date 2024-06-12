require 'integration_helper'
Dir[File.join(__dir__, '../../lib', '*.rb')].each { |file| require_relative file }

describe CreadorDeCalificacion do
  let(:creador_de_calificacion) do
    fecha = Time.iso8601('2024-06-02T21:34:40+0000')
    usuario = CreadorDeUsuario.new('rodrigo@gmail.com', 123_456_789).crear
    id_pelicula = CreadorDePelicula.new('Nair', 2024, 'drama').crear.id
    CreadorDeVisualizacion.new(usuario.email, id_pelicula, fecha)

    described_class.new(usuario.id_telegram, id_pelicula, 5)
  end

  let(:creador_de_calificacion_negativa) do
    fecha = Time.iso8601('2024-06-02T21:34:40+0000')
    usuario = CreadorDeUsuario.new('rodrigo@gmail.com', 123_456_789).crear
    id_pelicula = CreadorDePelicula.new('Nair', 2024, 'drama').crear.id
    CreadorDeVisualizacion.new(usuario.email, id_pelicula, fecha)

    described_class.new(usuario.id_telegram, id_pelicula, -1)
  end

  let(:creador_de_calificacion_mayor_a_cinco) do
    fecha = Time.iso8601('2024-06-02T21:34:40+0000')
    usuario = CreadorDeUsuario.new('rodrigo@gmail.com', 123_456_789).crear
    id_pelicula = CreadorDePelicula.new('Nair', 2024, 'drama').crear.id
    CreadorDeVisualizacion.new(usuario.email, id_pelicula, fecha)

    described_class.new(usuario.id_telegram, id_pelicula, 6)
  end

  let(:creador_de_calificacion_pelicula_inexistente) do
    usuario = CreadorDeUsuario.new('rodrigo@gmail.com', 123_456_789).crear

    described_class.new(usuario.id_telegram, 111_111_111, 3)
  end

  describe 'crear' do
    it 'dado que el id_telegram, id_pelicula y calificacion son válidos se crea y se guarda una calificacion' do
      calificacion = creador_de_calificacion.crear

      expect(calificacion.id).to be > 0
      expect(calificacion.calificacion).to eq 5
    end

    it 'debe levantar un error cuando la calificacion es negativa' do
      expect { creador_de_calificacion_negativa.crear }.to raise_error(ErrorAlInstanciarCalificacionInvalida)
    end

    it 'debe levantar un error cuando la calificacion es mayor a 5' do
      expect { creador_de_calificacion_mayor_a_cinco.crear }.to raise_error(ErrorAlInstanciarCalificacionInvalida)
    end

    it 'debe levantar un error cuando el contenido a calificar es inexistente' do
      expect { creador_de_calificacion_pelicula_inexistente.crear }.to raise_error(ErrorPeliculaInexistente)
    end
  end
end
