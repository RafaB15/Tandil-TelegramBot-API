# language: es
Característica: Consultar los contenidos más vistos

Antecedentes:

  Dado que existe un usuario con email "fer@gmail.com" y id_telegram 123456789
  Dado que existen 3 contenidos en la plataforma
  Dado que hay 3 contenidos vistos en la plataforma

@wip
Escenario: US23 - 01 Lista de favoritos con una sola pelicula
 
    Dado que marco la película "Batman" como favorita
    Cuando quiero ver mis favoritos
    Entonces aparece "Batman" en el listado

@wip
Escenario: US23 - 01 Lista de favoritos con 3 peliculas
     
    Dado que marco la película "Batman", "Nahir" y "Amor" como favoritas
    Cuando quiero ver mis favoritos
    Entonces aparece "Batman", "Nahir" y "Amor" en el listado