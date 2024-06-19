# language: es
Característica: Detallar contenido via informacion de API externa   

    Escenario: US22.1 - 01 Como cinefilo quiero detalles acerca de una pelicula
        Dado que existe el contenido "Titanic" 1997 "drama" "pelicula"
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver la informacion esperada

    Escenario: US22.1 - 02 La pelicula no está en nuestra BD
        Dado que no hay contenidos en la BD
        Cuando el cinefilo pide detalles acerca de la pelicula "PeliculaQueNoEstaEnNuestraBDD" con su ID
        Entonces debería ver un mensaje de error de que no está lo que busca en nuestra BDD
  
    Escenario: US22.1 - 03 La película está en nuestra BD pero OMDB no la tiene
        Dado que existe el contenido "EstaPeliNoExisteEnOMDB" 1997 "drama" "pelicula"
        Cuando el cinefilo pide detalles acerca de la pelicula "EstaPeliNoExisteEnOMDB" con su ID
        Entonces debería ver un mensaje que no se pueden mostrar detalles adicionales

    Escenario: US22.1 - 04 La pelicula está en OMDB pero no tiene todos los campos que queremos
        Dado que existe el contenido "PeliculaSinDirectorNiPremiosEnOMDB" 1997 "drama" "pelicula"
        Cuando el cinefilo pide detalles acerca de la pelicula "PeliculaSinDirectorNiPremiosEnOMDB" con su ID
        Entonces debería ver el campo "director" como no disponible
        Y debería ver el campo "premios" como no disponible

    Escenario: US22.2 - 01 La pelicula buscada fue vista por el usuario
        Dado un usuario "juan@gmail.com" 123456789
        Y que existe el contenido "Titanic" 1997 "drama" "pelicula"
        Y que el usuario ya lo vio 
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería mostrar que ya fue visto
    
    Escenario: US22.2 - 02 La pelicula buscada no fue vista por el usuario
        Dado un usuario "juan@gmail.com" 123456789
        Y que existe el contenido "Titanic" 1997 "drama" "pelicula"
        Y que el usuario no lo vio
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería mostrar que no fue visto

    Escenario: US27 - 01 Como cinefilo quiero detalles acerca de una serie
        Dado que existe la temporada "The Good Doctor - Temporada 1" 2017 "comedia" 18 en la base de datos
        Cuando el cinefilo pide detalles acerca de la serie "The Good Doctor - Temporada 1" con su ID
        Entonces debería ver la informacion esperada

    Escenario: US27 - 02 La serie no está en nuestra BD
        Dado que no hay contenidos en la BD
        Cuando el cinefilo pide detalles acerca de la serie "The Good Doctor - Temporada 1" con su ID
        Entonces debería ver un mensaje de error de que no está lo que busca en nuestra BDD

    @wip
    Escenario: US27 - 03 La serie está en nuestra BD pero OMDB no la tiene
        Dado que existe la temporada "estaserienoexisteenOMDB - Temporada 1" 2017 "comedia" 11 en la base de datos
        Cuando el cinefilo pide detalles acerca de la serie "estaserienoexisteenOMDB - Temporada 1" con su ID
        Entonces debería ver un mensaje que no se pueden mostrar detalles adicionales
    
    @wip
    Escenario: US27 - 04 La serie está en OMDB pero no tiene todos los campos que queremos
        Dado que existe el contenido "Friends - Temporada 1" 1994 "comedia" "serie" 24
        Cuando el cinefilo pide detalles acerca de la serie "Friends" con su ID
        Entonces debería ver el campo "director" como no disponible