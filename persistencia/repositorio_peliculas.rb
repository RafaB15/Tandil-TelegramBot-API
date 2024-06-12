require_relative './abstract_repository'
require 'date'

class ErrorAlPersistirPeliculaYaExistente < StandardError
  MSG_DE_ERROR = 'Error: pelicula ya existente'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class RepositorioPeliculas < AbstractRepository
  self.table_name = :peliculas
  self.model_class = 'Pelicula'

  def save(a_record)
    raise ErrorAlPersistirPeliculaYaExistente if find_by_titulo_y_anio(a_record.titulo, a_record.anio)

    super(a_record)
  end

  def find_by_titulo_y_anio(titulo, anio)
    row = dataset.first(titulo:, anio:)
    load_object(row) unless row.nil?
  end

  def find_by_title(titulo)
    load_collection dataset.where(Sequel.like(:titulo, "%#{titulo}%", case_insensitive: true))
  end

  def ultimos_agregados
    load_collection dataset.where(Sequel.lit('peliculas.fecha_agregado >= ?', Date.today - 7))
  end

  protected

  def load_object(a_hash)
    genero_de_pelicula = Genero.new(a_hash[:genero])
    anio_de_estreno = AnioDeEstreno.new(a_hash[:anio])
    fecha_agregado = a_hash[:fecha_agregado]
    Pelicula.new(a_hash[:titulo], anio_de_estreno, genero_de_pelicula, fecha_agregado, a_hash[:id])
  end

  def changeset(pelicula)
    {
      titulo: pelicula.titulo,
      anio: pelicula.anio,
      genero: pelicula.genero,
      fecha_agregado: pelicula.fecha_agregado
    }
  end
end
