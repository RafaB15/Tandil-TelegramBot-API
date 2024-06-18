# language: es
Característica: Consultar los contenidos más vistos

Antecedentes:
  Dado que existe un usuario con email "fer@gmail.com" y id_telegram 123456789
  Dado que existen 3 peliculas en la plataforma
  Dado que hay 3 peliculas vistos en la plataforma

Escenario: US23 - 01 Lista de favoritos con una sola pelicula
  Dado que marco la pelicula "Batman" como favorita
  Cuando quiero ver mis favoritos
  Entonces aparece "Batman" en el listado

Escenario: US23 - 01 Lista de favoritos con 3 peliculas
  Dado que marco la pelicula "Batman" como favorita
  Y que marco la pelicula "Nahir" como favorita
  Y que marco la pelicula "Amor" como favorita
  Cuando quiero ver mis favoritos
  Entonces aparece "Batman" en el listado
  Y aparece "Nahir" en el listado
  Y aparece "Amor" en el listado

Escenario: US23 - 04 Pelicula en plataforma sin marca de favorito no aparece
  Dado que marco las peliculas "Nahir" y "Amor" como favoritas
  Dado que no marco "Batman" como favorita
  Cuando quiero ver mis favoritos
  Entonces aparece "Amor" en el listado
  Y aparece "Nahir" en el listado