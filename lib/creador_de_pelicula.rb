require_relative '../dominio/pelicula'

class ErrorAlInstanciarPeliculaTituloInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: titulo invalido'.freeze

  def initiliza(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class CreadorDePelicula
  def initialize(titulo, anio, genero)
    @titulo = titulo
    @anio = anio
    @genero = genero
  end

  def crear
    raise ErrorAlInstanciarPeliculaTituloInvalido unless es_titulo_valido?

    anio_de_estreno = AnioDeEstreno.new(@anio)
    pelicula = Pelicula.new(@titulo, anio_de_estreno, @genero)
    RepositorioPeliculas.new.save(pelicula)

    pelicula
  rescue StandardError => _e
    raise
  end

  private

  def es_titulo_valido?
    !@titulo.nil?
  end
end
