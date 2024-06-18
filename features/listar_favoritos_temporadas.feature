# language: es
Característica: Consultar los contenidos más vistos

Antecedentes:
  Dado un usuario "juan@gmail.com" 123456789
  Y que existe la temporada "Suits - Temporada 2" 2010 "drama" 24 en la base de datos
  Y que existe la temporada "Suits - Temporada 3" 2011 "drama" 22 en la base de datos
  Y que existe la temporada "Suits - Temporada 4" 2011 "drama" 24 en la base de datos
  Y que existe la pelicula "Titanic" 1997 "drama" en la base de datos

  @current
  Escenario: US30 - 01 Lista de favoritos con una sola temporada
    Dado que marco el contenido "Suits - Temporada 2" como favorito
    Cuando quiero ver mis favoritos
    Entonces aparece "Suits - Temporada 2" en el listado

  @current
  Escenario: US30 - 02 Lista de favoritos con series y peliculas
    Dado que marco el contenido "Suits - Temporada 2" como favorito
    Y que marco el contenido "Suits - Temporada 3" como favorito
    Y que marco el contenido "Titanic" como favorito
    Cuando quiero ver mis favoritos
    Entonces aparece "Suits - Temporada 2" en el listado
    Y aparece "Suits - Temporada 3" en el listado
    Y aparece "Titanic" en el listado