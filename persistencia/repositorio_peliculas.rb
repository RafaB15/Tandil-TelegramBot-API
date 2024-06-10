require_relative './abstract_repository'

class ErrorAlPersistirPeliculaYaExistente < StandardError
  MSG_DE_ERROR = 'Error: pelicula ya existente'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
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
    row = dataset.first(titulo:)
    load_object(row) unless row.nil?
  end

  protected

  def load_object(a_hash)
    genero_de_pelicula = Genero.new(a_hash[:genero])
    anio_de_estreno = AnioDeEstreno.new(a_hash[:anio])
    Pelicula.new(a_hash[:titulo], anio_de_estreno, genero_de_pelicula, a_hash[:id])
  end

  def changeset(pelicula)
    {
      titulo: pelicula.titulo,
      anio: pelicula.anio,
      genero: pelicula.genero
    }
  end
end
