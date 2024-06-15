require_relative '../dominio/pelicula'

class ErrorAlInstanciarPeliculaTituloInvalido < ArgumentError
  MSG_DE_ERROR = 'Error: titulo invalido'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class ErrorPeliculaInexistente < StandardError
  MSG_DE_ERROR = 'Error: pelicula inexistente'.freeze

  def initialize(msg_de_error = MSG_DE_ERROR)
    super(msg_de_error)
  end
end

class CreadorDePelicula
  def initialize(titulo, anio, genero, fecha_agregado = Date.today)
    @titulo = titulo
    @anio = anio
    @genero = genero
    @fecha_agregado = fecha_agregado
  end

  def crear
    raise ErrorAlInstanciarPeliculaTituloInvalido unless es_el_titulo_valido?

    genero_de_pelicula = Genero.new(@genero)
    pelicula = Pelicula.new(@titulo, @anio, genero_de_pelicula, @fecha_agregado)

    RepositorioPeliculas.new.save(pelicula)
    pelicula
  rescue NameError
    raise ErrorPeliculaInexistente
  end

  private

  def es_el_titulo_valido?
    !@titulo.nil? && !@titulo.empty?
  end
end
