# language: es
Característica: Consultar los contenidos más vistos

Antecedentes: 
        Dado que existe un usuario con email "fer@gmail.com" y id_telegram 123456789
        Dado que existen 3 peliculas en la plataforma
        Y que existe la pelicula "Titanic" 1974 "drama" en la base de datos
        Y que existe la temporada "Game of Thrones - Temporada 1" 2010 "drama" 24 en la base de datos
        Y que existe la temporada "Game of Thrones - Temporada 2" 2011 "drama" 24 en la base de datos

    
    Escenario: US14 - 01 Como cinefilo quiero consultar lista de peliculas mas vistos
        Dado que hay 3 peliculas vistos en la plataforma
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces se ve una lista de los 3 peliculas mas vistos
    
    Escenario: US14 - 02 Mas de 3 peliculas tuvieron la misma cantidad de visualizaciones maximas se resuelve alfabeticamente
        Dado que hay 4 peliculas: "Alfa", "Beta", "Gamma", "Delta"
        Y que los 4 peliculas son los mas vistos en la plataforma con la misma cantidad de vistas
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces se ve una lista de los 3 peliculas más vistos, seleccionados alfabéticamente: "Alfa", "Beta", "Delta"

    Escenario: US14 - 03 Hay menos de 3 peliculas visualizados
        Dado que solo hay 2 peliculas que obtuvieron visualizaciones
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces se ve una lista de 2 peliculas

    Escenario: US14 - 04 No hubo ninguna visualizacion
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces tengo un listado de vistos vacio

    @current
    Escenario: US32.1 - 01 Como cinefilo quiero consultar lista de contenidos mas vistos incluyendo temporadas de series
        Dado que se vio el contenido "Titanic"
        Y que se vio el contenido "Game of Thrones - Temporada 1"
        Y que se vio el contenido "Game of Thrones - Temporada 2"
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces "Titanic" está en la lista
        Y "Game of Thrones - Temporada 1" está en la lista
        Y "Game of Thrones - Temporada 2" está en la lista
        