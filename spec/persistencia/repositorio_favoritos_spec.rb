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
    pelicula = FabricaDeContenido.crear_contenido('Nair', 2024, genero_de_pelicula)
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

  it 'deberia poder listar todos los favoritos' do
    repositorio = described_class.new
    favorito = Favorito.new(usuario, pelicula)
    described_class.new.save(favorito)
    favoritos = repositorio.find_by_user(usuario.id)
    expect(favoritos[0].contenido.titulo).to eq 'Nair'
  end
end
