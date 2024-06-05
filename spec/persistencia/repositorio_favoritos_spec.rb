require 'integration_helper'
require_relative '../../dominio/favorito'
require_relative '../../persistencia/repositorio_favoritos'

describe RepositorioFavoritos do
  let(:usuario) do
    usuario = Usuario.new('nicopaez@gmail.com', 123_456_789)
    RepositorioUsuarios.new.save(usuario)
  end

  let(:pelicula) do
    genero_de_pelicula = Genero.new('drama')
    anio_de_estreno = AnioDeEstreno.new(2024)
    pelicula = Pelicula.new('Nair', anio_de_estreno, genero_de_pelicula)
    RepositorioPeliculas.new.save(pelicula)
  end

  let(:fecha) do
    Time.iso8601('2024-06-02T21:34:40+0000')
  end

  it 'deberia guardar y asignar id si el favorito es nuevo' do
    favorito = Favorito.new(usuario, pelicula)
    described_class.new.save(favorito)
    expect(favorito.id).not_to be_nil
  end
end
