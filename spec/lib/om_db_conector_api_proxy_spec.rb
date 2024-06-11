require 'integration_helper'
Dir[File.join(__dir__, '../../lib/om_db_conector_api', '*.rb')].each { |file| require_relative file }

ENV['APP_MODE'] = 'test'

describe OMDbConectorAPIProxy do
  subject(:pelicula) { instance_double(Pelicula, titulo: 'Titanic') }

  describe 'detallar_pelicula' do
    it 'afafafdsa' do
      titulo = pelicula.titulo
      respuesta = described_class.new.detallar_pelicula(titulo)

      expect(respuesta['estado']).to eq 200
      expect(respuesta['cuerpo']).not_to be_nil
    end
  end
end
