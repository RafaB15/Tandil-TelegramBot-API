# language: es
Característica: Detallar contenido via informacion de API externa   

    Escenario: US22.1 - 01 Como cinefilo quiero detalles acerca de una pelicula
        Dado que existe el contenido "Titanic" 1997 "drama"
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver la informacion esperada

    Escenario: US22.1 - 02 La pelicula no está en nuestra BD
        Dado que no hay contenidos en la BD
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver un mensaje de error de que no está lo que busca
  
    Escenario: US22.1 - 03 La película está en nuestra BD pero OMDB no la tiene
        Dado que existe el contenido "estapelinoexisteenOMDB" 1997 "drama"
        Cuando el cinefilo pide detalles acerca de la pelicula "estapelinoexisteenOMDB" con su ID
        Entonces debería ver un mensaje que no se pueden mostrar detalles adicionales

    Escenario: US22.1 - 04 La pelicula está en OMDB pero no tiene todos los campos que queremos
        Dado que existe el contenido "peliculasindirectorenOMDB" 1997 "drama"
        Cuando el cinefilo pide detalles acerca de la pelicula "peliculasindirectorenOMDB" con su ID
        Entonces debería ver el campo "director" como no disponible

    @wip
    Escenario: US22.2 - 01 La pelicula buscada fue vista por el usuario
        Dado un usuario "juan@gmail.com" 123456789
        Y que existe el contenido "Titanic" 1997 "drama"
        Y que el usuario ya lo vio 
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería mostrar que ya fue visto

    @wip
    Escenario: US22.1 - 02 La pelicula buscada no fue vista por el usuario
        Dado un usuario "juan@gmail.com" 123456789
        Y que existe el contenido "Titanic" 1997 "drama"
        Y que el usuario no lo vio
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería mostrar que no fue visto