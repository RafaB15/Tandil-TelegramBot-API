# language: es
Característica: Consultar los contenidos más vistos

Antecedentes: 
    Dado un usuario "pepito@gmail.com" 123456789
    Y que existe la pelicula "Titanic" 1974 "drama" en la base de datos
    Y que existe la temporada "Game of Thrones - Temporada 1" 2010 "drama" 24 en la base de datos
    Y que existe la temporada "Game of Thrones - Temporada 2" 2011 "drama" 24 en la base de datos

    Escenario: US32.1 - 01 Como cinefilo quiero consultar lista de contenidos mas vistos incluyendo temporadas de series
        Dado que se vio el contenido "Titanic"
        Y que se vieron 4 capitulos de la temporada "Game of Thrones - Temporada 1"
        Y que se vieron 4 capitulos de la temporada "Game of Thrones - Temporada 2"
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces "Titanic" está en la lista
        Y "Game of Thrones - Temporada 1" está en la lista
        Y "Game of Thrones - Temporada 2" está en la lista

    Escenario: US32.2 - 02 Mas de 3 contenidos tuvieron la misma cantidad de visualizaciones maximas se resuelve alfabeticamente
        Dado que existe la temporada "Alpha" 2010 "drama" 24 en la base de datos
        Y que existe la temporada "Beta" 2010 "drama" 24 en la base de datos
        Y que existe la temporada "Delta" 2010 "drama" 24 en la base de datos
        Y que existe la temporada "Gamma" 2010 "drama" 24 en la base de datos
        Y que se vieron 4 capitulos de la temporada "Alpha"
        Y que se vieron 4 capitulos de la temporada "Beta"
        Y que se vieron 4 capitulos de la temporada "Delta"
        Y que se vieron 4 capitulos de la temporada "Gamma"
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces "Alpha" está en la lista
        Y "Beta" está en la lista
        Y "Delta" está en la lista
        Y "Gamma" no está en la lista

    Escenario: US32.2 - 03 Hay menos de 3 contenidos visualizados
        Dado que existe la temporada "Alpha" 2010 "drama" 24 en la base de datos
        Y que existe la temporada "Beta" 2010 "drama" 24 en la base de datos
        Y que se vieron 4 capitulos de la temporada "Alpha"
        Y que se vieron 4 capitulos de la temporada "Beta"
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces "Alpha" está en la lista
        Y "Beta" está en la lista

    Escenario: US32.2 - 04 No hubo ninguna visualizacion
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces tengo un listado de vistos vacio