require 'rspec'
require_relative '../../dominio/plataforma'

describe 'registrar_favorito' do
  let(:repositorio_usuarios) { instance_double('RepositorioUsuarios') }
  let(:repositorio_contenidos) { instance_double('RepositorioContenidos') }
  let(:repositorio_favoritos) { instance_double('RepositorioFavoritos') }
  let(:usuario) { instance_double('Usuario') }
  let(:pelicula) { instance_double('Pelicula') }
  let(:favorito) { instance_double('Favorito') }
  let(:plataforma) { Plataforma.new(123, 456) }

  before(:each) do
    allow(repositorio_usuarios).to receive(:find_by_id_telegram).and_return(usuario)
    allow(repositorio_contenidos).to receive(:find).and_return(pelicula)
    allow(repositorio_favoritos).to receive(:save)
    allow(Favorito).to receive(:new).and_return(favorito)
  end

  it 'should create and save a new favorite' do
    expect(Favorito).to receive(:new).with(usuario, pelicula)
    expect(repositorio_favoritos).to receive(:save).with(favorito)

    result = plataforma.registrar_favorito(repositorio_usuarios, repositorio_contenidos, repositorio_favoritos)

    expect(result).to eq(favorito)
  end
end
